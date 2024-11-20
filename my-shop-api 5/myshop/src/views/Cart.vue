<template>
  <div class="cart">
    <h1>Your Cart</h1>

    <div v-if="cart.length > 0" class="cart-content">
      <ul>
        <li v-for="item in cart" :key="item.id" class="cart-item">
          <div class="item-image" :style="{ backgroundImage: `url(${item.image_url || 'https://via.placeholder.com/150'})` }"></div>
          <div class="item-details">
            <h2>{{ item.name }}</h2>
            <p><strong>Price:</strong> {{ item.price }} €</p>
            <p><strong>Quantity:</strong> {{ item.quantity }}</p>
            <button @click="removeFromCart(item.id)" class="remove-button">Remove</button>
          </div>
        </li>
      </ul>

      <div class="cart-summary">
        <p><strong>Total:</strong> {{ total }} €</p>
        <button @click="handlePurchase" class="purchase-button">Complete Purchase</button>
      </div>
    </div>

    <div v-else class="empty-cart">
      <p>Your cart is empty.</p>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions } from "vuex";

export default {
  name: "Cart",
  computed: {
    ...mapState(["cart"]),
    total() {
      return this.cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
    },
  },
  methods: {
    ...mapMutations(["removeFromCart"]),
    ...mapActions(["completePurchase"]),
    removeFromCart(productId) {
      this.$store.commit("removeFromCart", productId);
    },
    handlePurchase() {
      this.completePurchase()
        .then(() => {
          alert("Your purchase was successfully completed!");
          this.$router.push("/purchase-history");
        })
        .catch((err) => {
          console.error("Error completing purchase:", err);
          alert("An error occurred during the purchase. Please try again.");
        });
    },
  },
};
</script>

<style scoped>
.cart {
  padding: 20px;
  max-width: 800px;
  margin: auto;
  font-family: Arial, sans-serif;
}

h1 {
  font-size: 2rem;
  color: #333;
  margin-bottom: 20px;
  text-align: center;
}

.cart-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

ul {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

.cart-item {
  display: flex;
  gap: 20px;
  align-items: center;
  border: 1px solid #ddd;
  padding: 10px;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.item-image {
  width: 100px;
  height: 100px;
  background-size: cover;
  background-position: center;
  border-radius: 10px;
  flex-shrink: 0;
}

.item-details {
  flex-grow: 1;
}

h2 {
  font-size: 1.5rem;
  color: #333;
  margin-bottom: 10px;
}

p {
  font-size: 1rem;
  margin: 5px 0;
}

.remove-button {
  background-color: #ffcdd2;
  color: #c62828;
  border: none;
  padding: 5px 10px;
  cursor: pointer;
  border-radius: 5px;
  transition: background-color 0.3s ease-in-out;
}

.remove-button:hover {
  background-color: #ef9a9a;
}

.cart-summary {
  text-align: right;
  font-size: 1.2rem;
  font-weight: bold;
}

.purchase-button {
  display: inline-block;
  margin-top: 20px;
  background-color: #b2f2bb;
  color: white;
  border: none;
  padding: 10px 20px;
  font-size: 1rem;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease-in-out;
}

.purchase-button:hover {
  background-color: #8ce99a;
}

.empty-cart {
  text-align: center;
  font-size: 1.5rem;
  color: #666;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  background-color: #f9f9f9;
}
</style>