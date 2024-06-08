const express = require('express');
const mongoose = require('mongoose');
const User = require('./Models/User');
const cors = require('cors');
require('dotenv').config();
const app = express();
const port = 3002;
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const secretKey = process.env.SECRET_KEY;

mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });
const db = mongoose.connection;

db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', () => {
  console.log('Connected to database');
});

app.use(express.json());
app.use(cors());

function generateToken(user) {
  return jwt.sign({ userId: user._id, name: user.name }, secretKey, { expiresIn: '1h' });
}

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


app.post('/login', async (req, res) => {
  try {
      const { email, password } = req.body;
      const user = await User.findOne({ email });
      if (!user) {
          return res.status(401).send({ message: 'Invalid email' });
      }
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
          return res.status(401).send({ message: 'Invalid password' });
      }
      const token = generateToken(user);
      console.log(token);
      res.send({ token });
  } catch (error) {
      console.error('Error during login:', error);
      res.status(500).send({ message: 'Internal Server Error' });
  }
});

app.get('/getId', (req, res) => {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
  if (!token) {
      return res.status(401).json({ message: 'Token not provided' });
  }

  try {
      const decodedToken = jwt.decode(token);
      const id = decodedToken.userId;
      res.json({ id });
  } catch (error) {
      console.error('Error decoding token:', error);
      res.status(500).json({ message: 'Internal Server Error' });
  }
});

app.get('/getUsername', (req, res) => {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
  if (!token) {
      return res.status(401).json({ message: 'Token not provided' });
  }

  try {
      const decodedToken = jwt.decode(token);
      const name = decodedToken.name;
      res.json({ name });
  } catch (error) {
      console.error('Error decoding token:', error);
      res.status(500).json({ message: 'Internal Server Error' });
  }
});


app.get('/', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/:id', async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).send({ message: 'User not found' });
    }
    res.send(user);
  } catch (error) {
    res.status(500).send({ message: 'Internal server error' });
  }
});


app.post('/', async (req, res) => {
  const user = new User({
    name: req.body.name,
    email: req.body.email,
    password: req.body.password,
    points: 0,
    created: new Date()
  });

  try {
    const newUser = await user.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});


app.put('/:id', async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    user.name = req.body.name;
    user.email = req.body.email;
    user.password = req.body.password;
    user.birthDate = req.body.birthDate;
    user.gender = req.body.gender;
    user.weight = req.body.weight;
    user.height = req.body.height;
    user.updated = new Date();

    const updatedUser = await user.save();
    res.json(updatedUser);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.put('/points/:id',authenticateToken, async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    user.points = req.body.points;
    const updatedUser = await user.save();
    res.json(updatedUser);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.delete('/:id', async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    await user.remove();
    res.json({ message: 'User deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


app.listen(port, () => {
  console.log(`User server is running at http://localhost:${port}`);
});