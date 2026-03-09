import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

function Dashboard() {
  const [stats, setStats] = useState({ published: 0, drafts: 0, total: 0 });
  const navigate = useNavigate();
  const userName = localStorage.getItem('userName');

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const token = localStorage.getItem('token');
      const apiUrl = window.location.hostname === 'localhost' ? 'http://localhost:8002' : 'http://host.docker.internal:8002';
      const response = await axios.get(`${apiUrl}/dashboard/stats`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setStats(response.data);
    } catch (err) {
      console.error('Failed to fetch stats', err);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('userName');
    navigate('/login');
  };

  return (
    <div className="container">
      <div className="navbar">
        <h1>Welcome, {userName}!</h1>
        <div className="navbar-links">
          <button onClick={() => navigate('/dashboard')}>Dashboard</button>
          <button onClick={() => navigate('/blogs')}>My Blogs</button>
          <button onClick={() => navigate('/blogs/new')}>New Blog</button>
          <button onClick={handleLogout}>Logout</button>
        </div>
      </div>

      <div className="dashboard-stats">
        <div className="stat-card">
          <h3>Published Blogs</h3>
          <div className="number">{stats.published}</div>
        </div>
        <div className="stat-card">
          <h3>Draft Blogs</h3>
          <div className="number">{stats.drafts}</div>
        </div>
        <div className="stat-card">
          <h3>Total Blogs</h3>
          <div className="number">{stats.total}</div>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
