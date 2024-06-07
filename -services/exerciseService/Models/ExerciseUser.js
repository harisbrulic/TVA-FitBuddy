const mongoose = require('mongoose');

const exerciseUserSchema = new mongoose.Schema({
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
  created: { type: Date, default: Date.now },
  updated: { type: Date, default: Date.now }
});

const ExerciseUser = mongoose.models.ExerciseUser || mongoose.model('ExerciseUser', exerciseUserSchema, 'excercisesuser');

module.exports = ExerciseUser;
