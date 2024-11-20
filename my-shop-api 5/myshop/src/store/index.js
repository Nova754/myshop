import { createStore } from 'vuex';

export default createStore({
  state: {
    token: null,
    user: null,
    products: [],
    cart: [],
    purchaseHistory: [] // Historique des achats
  },
  mutations: {
    setToken(state, token) {
      state.token = token;
    },
    setUser(state, user) {
      state.user = user;
    },
    setProducts(state, products) {
      state.products = products;
    },
    addToCart(state, product) {
      const existingProduct = state.cart.find(item => item.id === product.id);
      if (existingProduct) {
        existingProduct.quantity += 1;
      } else {
        state.cart.push({ ...product, quantity: 1 });
      }
    },
    removeFromCart(state, productId) {
      state.cart = state.cart.filter(item => item.id !== productId);
    },
    clearCart(state) {
      state.cart = [];
    },
    updateProductQuantity(state, { productId, quantity }) {
      const product = state.cart.find(item => item.id === productId);
      if (product && quantity > 0) {
        product.quantity = quantity;
      } else if (product && quantity <= 0) {
        state.cart = state.cart.filter(item => item.id !== productId);
      }
    },
    addToPurchaseHistory(state, order) {
      state.purchaseHistory.push(order);
    }
  },
  actions: {
    login({ commit }, { email, password }) {
      return fetch('http://localhost/authentication_token', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email, password })
      })
        .then(response => {
          if (!response.ok) {
            throw new Error('Erreur lors de l’authentification. Code : ' + response.status);
          }
          return response.json();
        })
        .then(data => {
          if (data.token) {
            commit('setToken', data.token);
            localStorage.setItem('token', data.token);
          } else {
            throw new Error('Token non trouvé dans la réponse');
          }
        })
        .catch(err => {
          console.error('Erreur lors de la connexion :', err);
          throw err;
        });
    },
    logout({ commit }) {
      commit('setToken', null);
      commit('setUser', null);
      localStorage.removeItem('token');
    },
    fetchProducts({ commit }) {
      const token = localStorage.getItem('token');
      return fetch('http://localhost/api/products', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
        .then(response => {
          if (!response.ok) {
            throw new Error('Erreur lors de la récupération des produits. Code : ' + response.status);
          }
          return response.json();
        })
        .then(data => {
          commit('setProducts', data['hydra:member']);
        })
        .catch(err => {
          console.error('Erreur lors de la récupération des produits :', err);
          throw err;
        });
    },
    completePurchase({ state, commit }) {
      // Définir correctement la variable `order`
      const order = {
        id: Date.now(), // Génère un identifiant unique basé sur l'heure actuelle
        items: [...state.cart], // Copie les éléments du panier
        total: state.cart.reduce((sum, item) => sum + item.price * item.quantity, 0), // Calculer le total
        date: new Date().toISOString() // Enregistrer la date de la commande
      };
      commit('addToPurchaseHistory', order);
      commit('clearCart'); // Vider le panier après un achat
      alert('Achat complété avec succès');
    }
  },
  getters: {
    isAuthenticated: state => !!state.token,
    cartItemCount: state => state.cart.reduce((total, item) => total + item.quantity, 0),
    cartTotalPrice: state => state.cart.reduce((total, item) => total + item.price * item.quantity, 0),
    userRole: state => (state.user ? state.user.roles : []),
    cartItems: state => state.cart,
    purchaseHistory: state => state.purchaseHistory // Getter pour récupérer l'historique des achats
  },
  modules: {}
});