package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.*;
import com.ReSourcesRelationnelles.prod.dto.user.*;
import com.ReSourcesRelationnelles.prod.entity.Role;
import com.ReSourcesRelationnelles.prod.entity.RoleEnum;
import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.entity.UserStatusEnum;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import com.ReSourcesRelationnelles.prod.security.JwtUtil;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserServiceTest {

    @InjectMocks
    private UserService userService;

    @Mock
    private UserRepository userRepository;
    @Mock
    private RoleService roleService;
    @Mock
    private AuthenticationManager authenticationManager;
    @Mock
    private JwtUtil jwtUtils;
    @Mock
    private PasswordEncoder passwordEncoder;
    @Mock
    private SecurityUtils securityUtils;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    private User createUserWithRoleUser() {
        Role role = new Role();
        role.setName(RoleEnum.USER);
        User user = new User();
        user.setId(1L);
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        user.setRole(role);
        user.setStatus(UserStatusEnum.ACTIVE);
        user.setDeleted(false);
        return user;
    }

    @Test
    void createUser_Success() {
        RegisterDTO request = new RegisterDTO();
        request.setName("Nom");
        request.setFirstName("Prenom");
        request.setUsername("username");
        request.setEmail("email@example.com");
        request.setPassword("password");

        when(userRepository.existsByEmailAndDeletedFalse(request.getEmail())).thenReturn(false);
        when(userRepository.existsByUsernameAndDeletedFalse(request.getUsername())).thenReturn(false);

        Role role = new Role();
        role.setName(RoleEnum.USER);
        when(roleService.findByName(RoleEnum.USER)).thenReturn(Optional.of(role));
        when(passwordEncoder.encode(request.getPassword())).thenReturn("hashedPassword");

        User savedUser = new User(
                request.getName(),
                request.getFirstName(),
                request.getUsername(),
                request.getEmail(),
                "hashedPassword",
                role
        );
        when(userRepository.save(any(User.class))).thenReturn(savedUser);

        UserDTO result = userService.createUser(request);

        assertEquals(request.getUsername(), result.getUsername());
        verify(userRepository).save(any(User.class));
    }

    @Test
    void createUser_ThrowsBadRequest_WhenEmailExists() {
        RegisterDTO request = new RegisterDTO();
        request.setEmail("email@example.com");

        when(userRepository.existsByEmailAndDeletedFalse(request.getEmail())).thenReturn(true);

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.createUser(request));
        assertEquals("L'email est déjà utilisé.", ex.getMessage());
    }

    @Test
    void createUserWithRole_Success() {
        RegisterWithRoleDTO request = new RegisterWithRoleDTO();
        request.setName("Nom");
        request.setFirstName("Prenom");
        request.setUsername("username");
        request.setEmail("email@example.com");
        request.setPassword("password");
        request.setRole(RoleEnum.ADMIN);

        when(userRepository.existsByEmailAndDeletedFalse(request.getEmail())).thenReturn(false);
        when(userRepository.existsByUsernameAndDeletedFalse(request.getUsername())).thenReturn(false);

        Role role = new Role();
        role.setName(RoleEnum.ADMIN);
        when(roleService.findByName(RoleEnum.ADMIN)).thenReturn(Optional.of(role));
        when(passwordEncoder.encode(request.getPassword())).thenReturn("hashedPassword");

        User savedUser = new User(
                request.getName(),
                request.getFirstName(),
                request.getUsername(),
                request.getEmail(),
                "hashedPassword",
                role
        );
        when(userRepository.save(any(User.class))).thenReturn(savedUser);

        UserDTO result = userService.createUserWithRole(request);

        assertEquals(request.getUsername(), result.getUsername());
        assertEquals(RoleEnum.ADMIN, role.getName());
        verify(userRepository).save(any(User.class));
    }

    @Test
    void createUserWithRole_ThrowsBadRequest_WhenRoleIsNull() {
        RegisterWithRoleDTO request = new RegisterWithRoleDTO();
        request.setRole(null);

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.createUserWithRole(request));
        assertEquals("Le rôle est requis.", ex.getMessage());
    }

    @Test
    void loginUser_Success() {
        LoginDTO request = new LoginDTO();
        request.setUsername("testuser");
        request.setPassword("password");

        Authentication authentication = mock(Authentication.class);
        UserDetails userDetails = mock(UserDetails.class);

        when(authenticationManager.authenticate(any())).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(userDetails);
        when(userDetails.getUsername()).thenReturn(request.getUsername());

        User user = createUserWithRoleUser();
        when(userRepository.findByUsernameAndDeletedFalse(request.getUsername())).thenReturn(user);
        when(jwtUtils.generateToken(user.getUsername(), user.getRole().getName().name())).thenReturn("token123");

        TokenDTO tokenDTO = userService.loginUser(request);

        assertEquals("token123", tokenDTO.getToken());
        assertEquals(user.getId(), tokenDTO.getId());
    }

    @Test
    void loginUser_ThrowsNotFound_WhenUserNotFound() {
        LoginDTO request = new LoginDTO();
        request.setUsername("testuser");
        request.setPassword("password");

        Authentication authentication = mock(Authentication.class);
        UserDetails userDetails = mock(UserDetails.class);

        when(authenticationManager.authenticate(any())).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(userDetails);
        when(userDetails.getUsername()).thenReturn(request.getUsername());

        when(userRepository.findByUsernameAndDeletedFalse(request.getUsername())).thenReturn(null);

        NotFoundException ex = assertThrows(NotFoundException.class, () -> userService.loginUser(request));
        assertEquals("Utilisateur introuvable.", ex.getMessage());
    }

    @Test
    void loginUser_ThrowsBadRequest_WhenUserInactive() {
        LoginDTO request = new LoginDTO();
        request.setUsername("testuser");
        request.setPassword("password");

        Authentication authentication = mock(Authentication.class);
        UserDetails userDetails = mock(UserDetails.class);

        when(authenticationManager.authenticate(any())).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(userDetails);
        when(userDetails.getUsername()).thenReturn(request.getUsername());

        User user = createUserWithRoleUser();
        user.setStatus(UserStatusEnum.INACTIVE);
        when(userRepository.findByUsernameAndDeletedFalse(request.getUsername())).thenReturn(user);

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.loginUser(request));
        assertEquals("Ce compte est désactivé. Veuillez contacter un administrateur.", ex.getMessage());
    }

    @Test
    void getUserById_Success() {
        User user = createUserWithRoleUser();

        when(userRepository.findByIdAndDeletedFalse(1L)).thenReturn(Optional.of(user));

        UserDTO userDTO = userService.getUserById(1L);

        assertEquals(user.getUsername(), userDTO.getUsername());
    }

    @Test
    void getUserById_ThrowsNotFound_WhenUserDoesNotExist() {
        when(userRepository.findByIdAndDeletedFalse(1L)).thenReturn(Optional.empty());

        NotFoundException ex = assertThrows(NotFoundException.class, () -> userService.getUserById(1L));
        assertEquals("L'utilisateur avec l'ID '1' n'existe pas.", ex.getMessage());
    }

    @Test
    void getUserById_ThrowsBadRequest_WhenRoleIsNotUser() {
        User user = createUserWithRoleUser();
        user.getRole().setName(RoleEnum.ADMIN);

        when(userRepository.findByIdAndDeletedFalse(1L)).thenReturn(Optional.of(user));

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.getUserById(1L));
        assertEquals("Seuls les utilisateurs avec le rôle USER peuvent être consultés.", ex.getMessage());
    }

    @Test
    void getAllUsers_Success() {
        User user = createUserWithRoleUser();
        when(userRepository.findAllByDeletedFalse()).thenReturn(List.of(user));

        List<UserDTO> users = userService.getAllUsers();

        assertFalse(users.isEmpty());
        assertEquals(user.getUsername(), users.get(0).getUsername());
    }

    @Test
    void updateUser_Success() {
        User user = createUserWithRoleUser();

        UpdateUserDTO request = new UpdateUserDTO();
        request.setName("NewName");
        request.setFirstName("NewFirstName");
        request.setUsername("newusername");
        request.setEmail("newemail@example.com");
        request.setPassword("newpassword");

        when(userRepository.findByIdAndDeletedFalse(user.getId())).thenReturn(Optional.of(user));
        when(userRepository.existsByUsernameAndDeletedFalse(request.getUsername())).thenReturn(false);
        when(userRepository.existsByEmailAndDeletedFalse(request.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(request.getPassword())).thenReturn("hashedNewPassword");
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArguments()[0]);

        UserDTO updatedUserDTO = userService.updateUser(user.getId(), request);

        assertEquals("NewName", updatedUserDTO.getName());
        assertEquals("NewFirstName", updatedUserDTO.getFirstName());
        assertEquals("newusername", updatedUserDTO.getUsername());
        assertEquals("newemail@example.com", updatedUserDTO.getEmail());
    }

    @Test
    void updateUser_ThrowsNotFound_WhenUserDoesNotExist() {
        when(userRepository.findByIdAndDeletedFalse(1L)).thenReturn(Optional.empty());

        UpdateUserDTO request = new UpdateUserDTO();

        NotFoundException ex = assertThrows(NotFoundException.class, () -> userService.updateUser(1L, request));
        assertEquals("L'utilisateur '1' n'existe pas.", ex.getMessage());
    }

    @Test
    void updateUser_ThrowsBadRequest_WhenRoleIsNotUser() {
        User user = createUserWithRoleUser();
        user.getRole().setName(RoleEnum.ADMIN);

        when(userRepository.findByIdAndDeletedFalse(user.getId())).thenReturn(Optional.of(user));

        UpdateUserDTO request = new UpdateUserDTO();

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.updateUser(user.getId(), request));
        assertEquals("Seuls les utilisateurs avec le rôle USER peuvent être modifié.", ex.getMessage());
    }

    @Test
    void updateUser_ThrowsBadRequest_WhenUsernameExists() {
        User user = createUserWithRoleUser();

        UpdateUserDTO request = new UpdateUserDTO();
        request.setUsername("existingUsername");

        when(userRepository.findByIdAndDeletedFalse(user.getId())).thenReturn(Optional.of(user));
        when(userRepository.existsByUsernameAndDeletedFalse(request.getUsername())).thenReturn(true);

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.updateUser(user.getId(), request));
        assertEquals("Le username est déjà utilisé.", ex.getMessage());
    }

    @Test
    void updateUser_ThrowsBadRequest_WhenEmailExists() {
        User user = createUserWithRoleUser();

        UpdateUserDTO request = new UpdateUserDTO();
        request.setEmail("existing@example.com");

        when(userRepository.findByIdAndDeletedFalse(user.getId())).thenReturn(Optional.of(user));
        when(userRepository.existsByEmailAndDeletedFalse(request.getEmail())).thenReturn(true);

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.updateUser(user.getId(), request));
        assertEquals("L'email est déjà utilisé.", ex.getMessage());
    }

    @Test
    void getCurrentUser_ReturnsUserDTO() {
        Authentication authentication = mock(Authentication.class);
        User user = createUserWithRoleUser();

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);

        UserDTO dto = userService.getCurrentUser(authentication);

        assertEquals(user.getUsername(), dto.getUsername());
    }

    @Test
    void updateCurrentUser_Success() {
        Authentication authentication = mock(Authentication.class);
        User user = createUserWithRoleUser();

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(userRepository.findByIdAndDeletedFalse(user.getId())).thenReturn(Optional.of(user));
        when(userRepository.existsByUsernameAndDeletedFalse(anyString())).thenReturn(false);
        when(userRepository.existsByEmailAndDeletedFalse(anyString())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPass");
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArguments()[0]);

        UpdateUserDTO request = new UpdateUserDTO();
        request.setName("UpdatedName");

        UserDTO updatedUserDTO = userService.updateCurrentUser(authentication, request);

        assertEquals("UpdatedName", updatedUserDTO.getName());
    }

    @Test
    void deleteCurrentUser_Success() {
        Authentication authentication = mock(Authentication.class);
        User user = createUserWithRoleUser();

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(userRepository.save(user)).thenReturn(user);

        MessageDTO message = userService.deleteCurrentUser(authentication);

        assertEquals("Utilisateur supprimé avec succès.", message.getMessage());
        assertTrue(user.isDeleted());
    }

    @Test
    void deleteUser_Success() {
        User user = createUserWithRoleUser();

        when(userRepository.findByIdAndDeletedFalse(user.getId())).thenReturn(Optional.of(user));
        when(userRepository.save(user)).thenReturn(user);

        MessageDTO message = userService.deleteUser(user.getId());

        assertEquals("Utilisateur supprimé avec succès.", message.getMessage());
        assertTrue(user.isDeleted());
    }

    @Test
    void deleteUser_ThrowsNotFound_WhenUserDoesNotExist() {
        when(userRepository.findByIdAndDeletedFalse(1L)).thenReturn(Optional.empty());

        NotFoundException ex = assertThrows(NotFoundException.class, () -> userService.deleteUser(1L));
        assertEquals("L'utilisateur '1' n'existe pas.", ex.getMessage());
    }

    @Test
    void deleteUser_ThrowsBadRequest_WhenRoleIsNotUser() {
        User user = createUserWithRoleUser();
        user.getRole().setName(RoleEnum.ADMIN);

        when(userRepository.findByIdAndDeletedFalse(user.getId())).thenReturn(Optional.of(user));

        BadRequestException ex = assertThrows(BadRequestException.class, () -> userService.deleteUser(user.getId()));
        assertEquals("Seuls les utilisateurs avec le rôle USER peuvent être supprimés.", ex.getMessage());
    }
}
