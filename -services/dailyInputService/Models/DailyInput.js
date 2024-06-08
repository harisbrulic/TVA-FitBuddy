const mongoose = require('mongoose');
const dailyInputSchema = new mongoose.Schema({
  water: Number,
  calories: Number,
  trainingFinished: Boolean,
  userId: String,
  date: Date,
  created: Date,
  updated: Date
});
const DailyInput = mongoose.model('Daily Input', dailyInputSchema, 'dailyInputs');
module.exports = DailyInput;
