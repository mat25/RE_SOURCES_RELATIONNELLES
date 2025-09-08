import axios from 'axios';
const backend = axios.create({ withCredentials: true });
backend.defaults.xsrfCookieName = 'XSRF-TOKEN';
backend.defaults.xsrfHeaderName = 'X-CSRF-TOKEN';
export default backend;
