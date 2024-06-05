const express = require('express');
const mongoose = require('mongoose');
const Exercise = require('./Models/Exercise');
const ExerciseUser = require('./Models/ExerciseUser');
const cors = require('cors');
require('dotenv').config();
const app = express();
const port = 3000;

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
    const exercises = await Exercise.find( /*userId === req.body.userId*/);
    res.json(exercises);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/favourites', async (req, res) => {
  try {
    const exercises = await ExerciseUser.find( /*userId === req.body.userId*/);
    res.json(exercises);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

/*app.get('/favourites', async (req, res) => {
  try {
    const exercises = await Exercise.find({ favourite: true && userId === req.body.userId });
    res.json(exercises);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});*/

app.get('/:id', async (req, res) => {
  try {
    const exercise = await Exercise.findById(req.params.id);
    if (!exercise) {
      return res.status(404).send({ message: 'Exercise not found' });
    }
    res.send(exercise);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});


app.post('/', async (req, res) => {
  const exercise = new Exercise({
    name: req.body.name,
    description: req.body.description,
    duration: req.body.duration,
    calories: req.body.calories,
    type: req.body.type,
    difficulty: req.body.difficulty,
    series: req.body.series,
    repetitions: req.body.repetitions,
    userId: req.body.userId,
    favourite: false,
    created: new Date(),
    updated: null
  });

  try {
    const newExercise = await exercise.save();
    res.status(201).json(newExercise);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});


app.put('/:id', async (req, res) => {
  try {
    const exercise = await Exercise.findById(req.params.id);
    if (!exercise) {
      return res.status(404).json({ message: 'Exercise not found' });
    }

    exercise.name = req.body.name;
    exercise.description = req.body.description;
    exercise.duration = req.body.duration;
    exercise.calories = req.body.calories;
    exercise.type = req.body.type;
    exercise.difficulty = req.body.difficulty;
    exercise.series = req.body.series;
    exercise.repetitions = req.body.repetitions;
    exercise.updated = new Date();

    const updatedExercise = await exercise.save();
    res.json(updatedExercise);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.put('/favourites/:id', async (req, res) => {
  try {
    const exercise = await Exercise.findById(req.params.id);
    if (!exercise) {
      return res.status(404).json({ message: 'Exercise not found' });
    }
    exercise.favourite = !exercise.favourite;
    const updatedExercise = await exercise.save();
    res.json(updatedExercise);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.delete('/:id', async (req, res) => {
  try {
    const exercise = await Exercise.findById(req.params.id);
    if (!exercise) {
      return res.status(404).json({ message: 'Exercise not found' });
    }

    await exercise.remove();
    res.json({ message: 'Exercise deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.listen(port, () => {
  console.log(`Exercise server is running at http://localhost:${port}`);
});