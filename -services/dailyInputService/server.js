const express = require('express');
const mongoose = require('mongoose');
const DailyInput = require('./Models/DailyInput');
const cors = require('cors');
require('dotenv').config();
const app = express();
const port = 3003;

mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });
const db = mongoose.connection;

db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', () => {
  console.log('Connected to database');
});

app.use(express.json());
app.use(cors());


app.get('/', async (req, res) => {
  try {
    const dailyInputs = await DailyInput.find( /*userId == req.body.userId*/);
    res.json(dailyInputs);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/:id', async (req, res) => {
  try {
    const dailyInput = await DailyInput.findById(req.params.id);
    if (!dailyInput) {
      return res.status(404).send({ message: 'Daily input not found' });
    }
    res.send(dailyInput);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});


app.post('/', async (req, res) => {
  const dailyInput = new DailyInput({
    water: req.body.water,
    calories: req.body.calories,
    trainingFinished: req.body.trainingFinished,
    date: req.body.date,
    userId: req.body.userId,
    created: new Date()
  });

  try {
    const newDailyInput = await dailyInput.save();
    res.status(201).json(newDailyInput);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});


app.put('/:id', async (req, res) => {
  try {
    const dailyInput = await DailyInput.findById(req.params.id);
    if (!dailyInput) {
      return res.status(404).json({ message: 'Daily input not found' });
    }

    dailyInput.water = req.body.water;
    dailyInput.calories = req.body.calories;
    dailyInput.trainingFinished = req.body.trainingFinished;
    dailyInput.date = req.body.date;
    dailyInput.updated = new Date();

    const updatedDailyInput = await dailyInput.save();
    res.json(updatedDailyInput);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.delete('/:id', async (req, res) => {
  try {
    const dailyInput = await DailyInput.findById(req.params.id);
    if (!dailyInput) {
      return res.status(404).json({ message: 'Daily input not found' });
    }

    await dailyInput.remove();
    res.json({ message: 'Daily input deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.listen(port, () => {
  console.log(`DailyInput server is running at http://localhost:${port}`);
});