<template>
  <div class="reset-password-request">
    <h1>Password Reset</h1>
    <p class="description">
      Enter your email address, and we will send you a link to reset your password.
    </p>
    <form @submit.prevent="requestPasswordReset" class="form-container">
      <div class="input-group">
        <label for="email">Email Address</label>
        <input
          id="email"
          v-model="email"
          type="email"
          placeholder="Enter your email address"
          required
        />
      </div>
      <button type="submit" class="submit-button">Send Link</button>
    </form>
    <p v-if="message" :class="['message', { error: isError }]">{{ message }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: "",
      message: "",
      isError: false,
    };
  },
  methods: {
    requestPasswordReset() {
      fetch("http://localhost/api/request-password-reset", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ email: this.email }),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error("Error while requesting password reset.");
          }
          return response.json();
        })
        .then(() => {
          this.message = "A reset link has been sent to your email address.";
          this.isError = false;
        })
        .catch((err) => {
          this.message = "Error while requesting password reset. Please try again.";
          this.isError = true;
          console.error(err);
        });
    },
  },
};
</script>

<style scoped>
.reset-password-request {
  max-width: 400px;
  margin: 30px auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  font-family: Arial, sans-serif;
}

h1 {
  font-size: 1.8rem;
  color: #333;
  text-align: center;
  margin-bottom: 10px;
}

.description {
  text-align: center;
  color: #666;
  margin-bottom: 20px;
}

.form-container {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.input-group {
  display: flex;
  flex-direction: column;
}

label {
  margin-bottom: 5px;
  font-size: 1rem;
  color: #444;
}

input {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 1rem;
}

input:focus {
  border-color: #333;
  outline: none;
  box-shadow: 0 0 4px rgba(39, 39, 39, 0.5);
}

.submit-button {
  padding: 10px;
  background-color: #898989;
  color: white;
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
}

.submit-button:hover {
  background-color: #333;
}

.message {
  margin-top: 15px;
  text-align: center;
  font-size: 1rem;
}

.message.error {
  color: #d9534f;
}

.message:not(.error) {
  color: #5cb85c;
}
</style>