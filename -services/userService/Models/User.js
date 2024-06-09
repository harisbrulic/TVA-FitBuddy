const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  _id: Number,
  name: String,
  email: String,
  password: String,
  gender: String,
  weight: Number,
  height: Number,
  points: { type: Number, default: 0 },
  created: Date,
  updated: Date
});

const User = mongoose.model('User', userSchema, 'users');

module.exports = User;