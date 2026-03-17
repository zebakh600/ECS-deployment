import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';

function BlogEditor() {
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const { id } = useParams();

  const API_URL = 'https://ecs.zeba.click/api/blog';

  useEffect(() => {
    if (id) {
      fetchBlog();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  const fetchBlog = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get(`${API_URL}/blogs/${id}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setTitle(response.data.title);
      setContent(response.data.content);
    } catch (err) {
      setError('Failed to load blog');
    }
  };

  const handleSave = async (status) => {
    setError('');

    if (!title.trim() || !content.trim()) {
      setError('Title and content are required');
      return;
    }

    try {
      const token = localStorage.getItem('token');
      const blogData = { title, content, status };

      if (id) {
        await axios.put(`${API_URL}/blogs/${id}`, blogData, {
          headers: { Authorization: `Bearer ${token}` }
        });
      } else {
        await axios.post(`${API_URL}/blogs`, blogData, {
          headers: { Authorization: `Bearer ${token}` }
        });
      }

      navigate('/blogs');
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to save blog');
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
        <h1>{id ? 'Edit Blog' : 'New Blog'}</h1>
        <div className="navbar-links">
          <button onClick={() => navigate('/dashboard')}>Dashboard</button>
          <button onClick={() => navigate('/blogs')}>My Blogs</button>
          <button onClick={() => navigate('/blogs/new')}>New Blog</button>
          <button onClick={handleLogout}>Logout</button>
        </div>
      </div>

      <div className="editor-container">
        <h2>{id ? 'Edit Your Blog' : 'Create New Blog'}</h2>
        {error && <div className="error">{error}</div>}

        <div className="form-group">
          <label>Blog Title</label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Enter blog title..."
          />
        </div>

        <div className="form-group">
          <label>Blog Content</label>
          <textarea
            value={content}
            onChange={(e) => setContent(e.target.value)}
            placeholder="Write your blog content here..."
          />
        </div>

        <div className="editor-actions">
          <button className="btn-draft" onClick={() => handleSave('draft')}>
            Save as Draft
          </button>
          <button className="btn-publish" onClick={() => handleSave('published')}>
            Publish
          </button>
        </div>
      </div>
    </div>
  );
}

export default BlogEditor;