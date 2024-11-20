<template>
  <div class="product-details">
    <div v-if="isLoading" class="loading-message">
      <img src="@/assets/loading.gif" alt="Loading product details..." class="load-img">
    </div>
  
    <div v-else-if="product" class="details-container">
      <button @click="goHome" class="go-home">
        <img src="@/assets/arrow.svg" alt="Go Home" class="home-icon" />
      </button>
      <div class="image-section">
        <div
          class="product-image"
          :style="{ backgroundImage: `url(${product.image_url || 'https://via.placeholder.com/400'})` }"
        ></div>
      </div>
  
      <div class="info-section">
        <h1>{{ product.name }}</h1>
        <p class="description">{{ product.description }}</p>

        <!-- Nouvelle div pour aligner le prix et le bouton -->
        <div class="price-and-button">
          <p class="price"><strong>Prix :</strong> {{ product.price }} €</p>
          <button @click="handleButtonClick" class="cart-button">
            <img src="@/assets/shop.svg" alt="Ajouter au panier" class="cart-icon" />
          </button>
        </div>
      </div>
    </div>
  
    <div v-else class="error-message">
      <p>Produit non trouvé.</p>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations } from "vuex";

export default {
  name: "DetailProduct",
  data() {
    return {
      product: null,
      isLoading: true,
    };
  },
  computed: {
    ...mapState(["token"]),
    isAuthenticated() {
      return !!this.token;
    },
  },
  methods: {
    ...mapMutations(["addToCart"]),
    fetchProduct() {
      const productId = this.$route.params.id;
      fetch(`http://localhost/api/products/${productId}`)
        .then((response) => response.json())
        .then((data) => {
          this.product = {
            ...data,
            image_url: data.image_url || "https://via.placeholder.com/400",
          };
          this.isLoading = false;
        })
        .catch((err) => {
          console.error("Erreur lors du chargement du produit :", err);
          this.isLoading = false;
        });
    },
    handleButtonClick() {
      if (this.isAuthenticated) {
        this.addToCart(this.product);
        alert("Produit ajouté au panier !");
      } else {
        this.$router.push("/login");
      }
    },
    goHome() {
      this.$router.push("/");
    },
  },
  created() {
    this.fetchProduct();
  },
};
</script>

<style scoped>
.product-details {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: 90vh;
  padding: 20px;
  font-family: Arial, sans-serif;
  background-color: #f8f9fa;
}

.loading-message,
.error-message {
  text-align: center;
  font-size: 1.25rem;
  color: #666;
}

.details-container {
  display: flex;
  flex-direction: column;
  width: 50%;
  gap: 20px;
  border: none;
  padding: 20px;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  position: relative;
}

.image-section {
  text-align: center;
}

.product-image {
  width: 100%;
  height: 400px;
  background-size: cover;
  background-position: center;
  border-radius: 10px;
}

.info-section {
  text-align: left;
  position: relative;
}

h1 {
  font-size: 2.5rem;
  color: #333;
  margin-bottom: 15px;
}

.description {
  font-size: 1.25rem;
  color: #555;
  margin-bottom: 15px;
}

/* Nouvelle classe pour aligner le prix et le bouton */
.price-and-button {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.price {
  font-size: 1.75rem;
  font-weight: bold;
  color: #007bff;
}

.cart-button {
  background: none;
  border: none;
  cursor: pointer;
  display: inline-flex;
  justify-content: center;
  align-items: center;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  transition: transform 0.3s ease, background-color 0.3s ease;
}

.cart-button:hover {
  transform: scale(1.1);
  background-color: rgba(0, 0, 0, 0.05);
}

.cart-icon {
  width: 40px;
  height: 40px;
}

.load-img {
  width: 50%;
  height: 50%;
  align-items: center;
}

.go-home {
  position: absolute;
  top: 20px;
  left: 20px;
  display: inline-flex;
  justify-content: center;
  align-items: center;
  padding: 10px;
  background-color: none;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s ease-in-out;
  width: 60px;
  height: 60px;
}

.go-home:hover {
  background-color: #cbcbcb;
}

.home-icon {
  width: 30px;
  height: 30px;
}
</style>
