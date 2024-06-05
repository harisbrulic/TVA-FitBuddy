const mongoose = require('mongoose');
const exerciseSchema = new mongoose.Schema({
  name: String,
  description: String,
  duration: Number,
  calories: Number,
  type: String,
  difficulty: String,
  series: Number,
  repetitions: String,
  favourite: Boolean,
  userId: String,
  created: Date,
  updated: Date
});
const Exercise = mongoose.model('Exercise', exerciseSchema, 'excercises');
module.exports = Exercise;
