const express = require('express');
const mongoose = require('mongoose');
const Training = require('./Models/Training');
const cors = require('cors');
require('dotenv').config();
const app = express();
const port = 3001;

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
    const trainings = await Training.find( /*userId == req.body.userId*/);
    res.json(trainings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/favourites', async (req, res) => {
  try {
    const trainings = await Training.find({ favourite: true && userId === req.body.userId });
    res.json(trainings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/:id', async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).send({ message: 'Training not found' });
    }
    res.send(training);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});


app.post('/', async (req, res) => {
  const training = new Training({
    name: req.body.name,
    duration: req.body.duration,
    calories: req.body.calories,
    difficulty: req.body.difficulty,
    userId: req.body.userId,
    exerciseIds: req.body.exerciseIds,
    favourite: false,
    created: new Date(),
    updated: null
  });

  try {
    const newTraining = await training.save();
    res.status(201).json(newTraining);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});


app.put('/:id', async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).json({ message: 'Training not found' });
    }

    training.name = req.body.name;
    training.description = req.body.description;
    training.duration = req.body.duration;
    training.calories = req.body.calories;
    training.type = req.body.type;
    training.difficulty = req.body.difficulty;
    training.series = req.body.series;
    training.repetitions = req.body.repetitions;
    training.updated = new Date();

    const updatedTraining = await training.save();
    res.json(updatedTraining);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.put('/favourites/:id', async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).json({ message: 'Training not found' });
    }
    training.favourite = !training.favourite;
    const updatedTraining = await training.save();
    res.json(updatedTraining);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.delete('/:id', async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).json({ message: 'Training not found' });
    }

    await training.remove();
    res.json({ message: 'Training deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.listen(port, () => {
  console.log(`Training server is running at http://localhost:${port}`);
});