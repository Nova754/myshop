<template>
  <div class="reset-password">
    <h1>Reset Your Password</h1>
    <p class="description">
      Please enter a new password to secure your account.
    </p>
    <form @submit.prevent="resetPassword" class="form-container">
      <div class="input-group">
        <label for="password">New Password</label>
        <input
          id="password"
          v-model="password"
          type="password"
          placeholder="Enter your new password"
          required
        />
      </div>
      <div class="input-group">
        <label for="confirm-password">Confirm Password</label>
        <input
          id="confirm-password"
          v-model="confirmPassword"
          type="password"
          placeholder="Confirm your password"
          required
        />
      </div>
      <button type="submit" class="submit-button">Reset Password</button>
    </form>
    <p v-if="message" :class="['message', { error: isError }]">{{ message }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      password: "",
      confirmPassword: "",
      message: "",
      isError: false,
    };
  },
  methods: {
    resetPassword() {
      if (this.password !== this.confirmPassword) {
        this.message = "Passwords do not match.";
        this.isError = true;
        return;
      }

      fetch("http://localhost/api/reset-password", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ password: this.password, token: this.$route.query.token }),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error("Error resetting the password");
          }
          return response.json();
        })
        .then(() => {
          this.message = "Your password has been successfully reset. You can now log in.";
          this.isError = false;
        })
        .catch((err) => {
          this.message = "Error resetting your password. Please try again.";
          this.isError = true;
          console.error(err);
        });
    },
  },
};
</script>

<style scoped>

.reset-password {
  max-width: 400px;
  margin: 30px auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  background-color: #ffffff;
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
  border-color: #007bff;
  outline: none;
  box-shadow: 0 0 4px rgba(0, 123, 255, 0.5);
}

.submit-button {
  padding: 10px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
}

.submit-button:hover {
  background-color: #0056b3;
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