const mongoose = require('mongoose');

const dailyInputSchema = new mongoose.Schema({
  water: Number,
  calories: Number,
  trainingFinished: Boolean,
  userId: String,
  date: Date, // To which date daily input belongs
  created: Date, // When daily input was created
  updated: Date
});

const DailyInput = mongoose.model('Daily Input', dailyInputSchema, 'dailyInputs');

module.exports = DailyInput;