const mongoose = require('mongoose');
const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
  birthDate: Date,
  gender: String,
  weight: Number,
  height: Number,
  points: Number,
  created: Date,
  updated: Date
});
const User = mongoose.model('User', userSchema, 'users');
module.exports = User;
