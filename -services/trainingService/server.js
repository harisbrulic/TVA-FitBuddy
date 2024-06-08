const express = require('express');
const mongoose = require('mongoose');
const Training = require('./Models/Training');
const cors = require('cors');
require('dotenv').config();
const app = express();
const port = 3001;
const jwt = require('jsonwebtoken');
const secretKey = process.env.SECRET_KEY;

mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });
const db = mongoose.connection;

db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', () => {
  console.log('Connected to database');
});

app.use(express.json());
app.use(cors());


function authenticateToken(req, res, next) {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
  if (!token) {
    console.log('Token not provided');
    return res.status(401).json({ message: 'Token not provided' });
  }
  jwt.verify(token, secretKey, (err, user) => {
    if (err) {
      console.log('Invalid token:', err.message);
      return res.status(403).json({ message: 'Invalid token' });
    }
    console.log('User authenticated:', user);
    req.user = user;
    next();
  });
}


// GET
// Pridobitev vseh treningov
app.get('/', authenticateToken, async (req, res) => {
  try {
    const trainings = await Training.find({ userId: req.user.userId });
    res.json(trainings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Pridobitev samo všečkanih treningov
app.get('/favorites/:id', async (req, res) => {
  try {
    const trainings = await Training.find({ favourite: true, userId: req.params.id });
    res.json(trainings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Pridobitev enega treninga
app.get('/:id', authenticateToken, async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).send({ message: 'Training not found' });
    }
    if (training.userId.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Forbidden' });
    }
    res.send(training);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});

app.get('/user/:id', authenticateToken, async (req, res) => {
  try {
    const training = await Training.find( {userId:req.params.id});
    if (!training) {
      return res.status(404).send({ message: 'Training not found' });
    }
    res.send(training);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});


// POST
// Vstavljanje treninga
app.post('/', authenticateToken, async (req, res) => {
  const training = new Training({
    name: req.body.name,
    duration: req.body.duration,
    calories: req.body.calories,
    difficulty: req.body.difficulty,
    userId: req.user.userId,
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


// PUT
// Posodabljanje treninga
app.put('/:id', authenticateToken, async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).json({ message: 'Training not found' });
    }
    if (training.userId.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Forbidden' });
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

// Všečkanje treninga
app.put('/favourites/:id', authenticateToken, async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).json({ message: 'Training not found' });
    }
    if (training.userId.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Forbidden' });
    }

    training.favourite = !training.favourite;
    const updatedTraining = await training.save();
    res.json(updatedTraining);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


// DELETE
// Brisanje treninga
app.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const training = await Training.findById(req.params.id);
    if (!training) {
      return res.status(404).json({ message: 'Training not found' });
    }
    if (training.userId.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Forbidden' });
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