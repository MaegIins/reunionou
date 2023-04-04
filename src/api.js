import axios from 'axios';

const api = axios.create({
  baseURL: 'http://docketu.iutnc.univ-lorraine.fr:20005/',
  timeout: 5000,
});

api.interceptors.request.use(
  (config) => {
    const token = sessionStorage.getItem('access_token');
    const urlParams = new URLSearchParams(window.location.search);
    const inviteKey = urlParams.get('key');

    if (config.url.includes('/invites') && inviteKey) {
      config.headers.Authorization = `Bearer ${inviteKey}`;
    } else if (token && config.url !== '/auth/refresh') {
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

    // Ajouter la vérification de l'URL
    const isInviteUrl = originalRequest.url.includes('/invites');

    if (error.response.status === 401 && !originalRequest._retry && originalRequest.url !== '/auth/refresh' && !isInviteUrl) {
      originalRequest._retry = true;

      // Reste du code pour gérer le refreshToken

    } else if (isInviteUrl) {
      // Si l'URL contient '/invites', ne faites rien et ne redirigez pas vers la page de connexion.
      return Promise.reject(error);
    }

    // Ajoutez cette condition pour éviter la redirection si l'URL contient '/invites'.
    if (!refreshToken && !isInviteUrl) {
      // Si le refreshToken n'est pas présent et que l'URL ne contient pas '/invites', redirigez l'utilisateur vers la page de connexion.
      window.location.href = '/login?error=refresh1';
    }

    return Promise.reject(error);
  }
);



export default api;