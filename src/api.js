// src/api.js
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3333/',
  timeout: 5000,
});

api.interceptors.request.use(
    (config) => {
      const token = sessionStorage.getItem('access_token');
      if (token && config.url !== '/auth/refresh') {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => {
      return Promise.reject(error);
    }
  );

api.interceptors.response.use(
  (response) => {
    return response;
  },
  async (error) => {
    const originalRequest = error.config;
    const refreshToken = sessionStorage.getItem('refresh_token');
    console.log('refreshToken', refreshToken)

    if (error.response.status === 401 && !originalRequest._retry && originalRequest.url !== '/auth/refresh') {
      originalRequest._retry = true;

      // Si le refreshToken est présent, essayez de rafraîchir l'access token.
      if (refreshToken) {
        try {
          // Appelez l'endpoint de rafraîchissement du token pour obtenir un nouveau access token.
          // Envoyez le refresh_token en tant que Bearer Token.
          const { data, status } = await api.post('/auth/refresh', {}, { headers: { Authorization: `Bearer ${refreshToken}` } });

          // Si le code d'état est 401, redirigez l'utilisateur vers la page de connexion.
          if (status === 401) {
           window.location.href = '/login?error=refresh3';
            return;
          }

          sessionStorage.setItem('access_token', data.access_token);
          originalRequest.headers.Authorization = `Bearer ${data.access_token}`;

          // Réessayez la requête originale avec le nouveau access token.
          return api(originalRequest);
        } catch (err) {
          // Gérer l'erreur de rafraîchissement du token (rediriger vers la page de connexion, par exemple)
          console.error('Error refreshing access token', err);
          window.location.href = '/login?error=refresh2';
        }
      } else {
        // Si le refreshToken n'est pas présent, redirigez l'utilisateur vers la page de connexion.
       window.location.href = '/login?error=refresh1';
      }
    }

    return Promise.reject(error);
  }
);

export default api;