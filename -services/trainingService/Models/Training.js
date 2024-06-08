const mongoose = require('mongoose');

const trainingSchema = new mongoose.Schema({
  name: String,
  duration: Number,
  calories: Number,
  difficulty: String,
  favourite: Boolean,
  userId: String,
  exerciseIds: [String],
  created: Date,
  updated: Date
});

const Training = mongoose.model('Training', trainingSchema, 'trainings');

module.exports = Training;
