const mongoose = require('mongoose');

const exerciseUserSchema = new mongoose.Schema({
  name: String,
  duration: Number,
  calories: Number,
  userId: String,
  created: { type: Date, default: Date.now },
  updated: { type: Date, default: Date.now }
});

const ExerciseUser = mongoose.models.ExerciseUser || mongoose.model('ExerciseUser', exerciseUserSchema, 'excercisesuser');

module.exports = ExerciseUser;
