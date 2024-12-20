import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import EditPage from './pages/EditPage';
import UserPage from './pages/UserPage';
import EventPage from './pages/EventPage';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/edit/:id" element={<EditPage />} />
        <Route path="/user" element={<UserPage />} />
        <Route path="/event" element={<EventPage />} />
      </Routes>
    </Router>
  );
}

export default App;
