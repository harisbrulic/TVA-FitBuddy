const express = require('express');
const mongoose = require('mongoose');
const DailyInput = require('./Models/DailyInput');
const cors = require('cors');
require('dotenv').config();
const app = express();
const port = 3003;
const jwt = require('jsonwebtoken');
const secretKey = process.env.SECRET_KEY;
const axios = require('axios');

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

async function updateUserPoints(userId, totalPoints, token) {
  try {
    const response = await axios.put(`http://localhost:3002/points/${userId}`, { points: totalPoints }, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    console.log(response);
    return response.data; 
  } catch (error) {
    throw new Error(error.message);
  }
}

async function fetchDailyInputs(userId, token) {
  try {
    const response = await axios.get(`http://localhost:3003/user/${userId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    console.log(response);
    return response.data; 
  } catch (error) {
    throw new Error(error.message);
  }
}

// računanje točke glede na dnevne vnose
function calculatePoints(dailyInput) {
  return dailyInput.calories / 10; // 1 point for every 10 calories
}

// Function to calculate total points from daily inputs
function calculateTotalPoints(dailyInputs) {
  let totalPoints = 0;
  dailyInputs.forEach(dailyInput => {
    totalPoints += calculatePoints(dailyInput);
  });
  return totalPoints;
}

// POST
// Dodajanje novega dnevnega vnosa
app.post('/', authenticateToken, async (req, res) => {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
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
    const dailyInputs = await fetchDailyInputs(req.body.userId, token); 
    const totalPoints = calculateTotalPoints(dailyInputs); 
    await updateUserPoints(req.body.userId, totalPoints, token);
    res.status(201).json(newDailyInput);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// GET
// Pridobitev vseh dnevnih vnosov
app.get('/', authenticateToken, async (req, res) => {
  try {
    const dailyInputs = await DailyInput.find( /*userId == req.body.userId*/);
    res.json(dailyInputs);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Pridobitev dnevnega vnosa po ID-ju
app.get('/:id', authenticateToken, async (req, res) => {
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

// Pridobitev dnevnega vnosa po datumu
app.get('/date/:date', authenticateToken, async (req, res) => {
  try {
    const dailyInput = await DailyInput.find({ date: req.params.date /*&& userId === req.body.userId*/ });
    if (!dailyInput) {
      return res.status(404).send({ message: 'Daily input not found' });
    }
    res.send(dailyInput);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});

// PUT
// Posodabljanje dnevnega vnosa
app.put('/:id', authenticateToken, async (req, res) => {
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


// DELETE
// Brisanje dnevnega vnosa
app.delete('/:id', authenticateToken, async (req, res) => {
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

app.get('/user/:id', authenticateToken, async (req, res) => {
  try {
    const dailyInput = await DailyInput.find( {userId:req.params.id});
    if (!dailyInput) {
      return res.status(404).send({ message: 'dailyInput not found' });
    }
    res.send(dailyInput);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});


app.listen(port, () => {
  console.log(`DailyInput server is running at http://localhost:${port}`);
});