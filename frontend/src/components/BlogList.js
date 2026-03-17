import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

function BlogList() {
  const [blogs, setBlogs] = useState([]);
  const navigate = useNavigate();

  const API_URL = 'https://ecs.zeba.click/api/blog';

  useEffect(() => {
    fetchBlogs();
  }, []);

  const fetchBlogs = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get(`${API_URL}/blogs`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setBlogs(response.data);
    } catch (err) {
      console.error('Failed to fetch blogs', err);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this blog?')) return;

    try {
      const token = localStorage.getItem('token');
      await axios.delete(`${API_URL}/blogs/${id}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      fetchBlogs();
    } catch (err) {
      console.error('Failed to delete blog', err);
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
        <h1>My Blogs</h1>
        <div className="navbar-links">
          <button onClick={() => navigate('/dashboard')}>Dashboard</button>
          <button onClick={() => navigate('/blogs')}>My Blogs</button>
          <button onClick={() => navigate('/blogs/new')}>New Blog</button>
          <button onClick={handleLogout}>Logout</button>
        </div>
      </div>

      <div className="blog-list">
        {blogs.length === 0 ? (
          <p style={{ textAlign: 'center', color: '#888' }}>No blogs yet. Create your first blog!</p>
        ) : (
          blogs.map((blog) => (
            <div key={blog._id} className="blog-item">
              <div>
                <h3>
                  {blog.title}
                  <span className={`status ${blog.status}`}>{blog.status}</span>
                </h3>
                <p style={{ color: '#888', fontSize: '14px' }}>
                  {new Date(blog.updated_at).toLocaleDateString()}
                </p>
              </div>
              <div className="blog-actions">
                <button className="btn-edit" onClick={() => navigate(`/blogs/edit/${blog._id}`)}>
                  Edit
                </button>
                <button className="btn-delete" onClick={() => handleDelete(blog._id)}>
                  Delete
                </button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default BlogList;