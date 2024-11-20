<template>
  <div class="purchase-history">
    <h1>Purchase History</h1>
   
    <div v-if="purchaseHistory.length > 0" class="history-content">
      <ul>
        <li v-for="purchase in purchaseHistory" :key="purchase.id" class="purchase-card">
          <div class="purchase-header">
            <h2>Purchase on {{ formatDate(purchase.date) }}</h2>
            <p><strong>Total:</strong> {{ purchase.total }} €</p>
          </div>
          <ul class="purchase-items">
            <li v-for="item in purchase.items" :key="item.id" class="item">
              <div class="item-details">
                <p>{{ item.name }}</p>
                <p>{{ item.quantity }} x {{ item.price }} €</p>
              </div>
            </li>
          </ul>
        </li>
      </ul>
    </div>
   
    <div v-else class="empty-history">
      <p>You have no purchase history yet.</p>
    </div>
  </div>
</template>
   
<script>
import { mapState } from "vuex";

export default {
  name: "PurchaseHistory",
  computed: {
    ...mapState(["purchaseHistory"]),
  },
  methods: {
    formatDate(date) {
      if (!date) return "Date not available";
      const parsedDate = new Date(date);
      if (isNaN(parsedDate)) return "Invalid date";
      return parsedDate.toLocaleDateString("en-US", {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric",
      });
    },
  },
};
</script>
   
<style scoped>
.purchase-history {
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

.history-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

ul {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

.purchase-card {
  border: 1px solid #ddd;
  padding: 15px;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.purchase-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #ddd;
  padding-bottom: 10px;
  margin-bottom: 10px;
}

h2 {
  font-size: 1.5rem;
  color: #333;
}

.purchase-items {
  padding-left: 0;
}

.item {
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #f0f0f0;
  padding: 8px 0;
}

.item-details p {
  margin: 0;
  font-size: 1rem;
}

.empty-history {
  text-align: center;
  font-size: 1.5rem;
  color: #666;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  background-color: #f9f9f9;
}
</style>