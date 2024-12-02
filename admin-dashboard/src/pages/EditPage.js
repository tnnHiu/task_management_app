import React, { useState, useEffect } from 'react';
import { doc, getDoc, updateDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { useNavigate, useParams } from 'react-router-dom';
import { Button, TextField, Select, MenuItem, FormControl, InputLabel } from '@mui/material';
import '../index.css';

const EditPage = () => {
  const { id } = useParams();
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [priority, setPriority] = useState('');
  const [status, setStatus] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const fetchTask = async () => {
      const docRef = doc(db, 'tasks', id);
      const docSnap = await getDoc(docRef);
      if (docSnap.exists()) {
        const data = docSnap.data();
        setName(data.name);
        setDescription(data.description);
        setPriority(data.priority || '');
        setStatus(data.status || '');
      }
    };

    fetchTask();
  }, [id]);

  const handleUpdate = async () => {
    const docRef = doc(db, 'tasks', id);
    await updateDoc(docRef, { name, description, priority, status });
    navigate('/');
  };

  return (
    <div style={{ padding: '20px' }} className='container'>
      <h1 className='title'>Sửa nhiệm vụ</h1>

      <label htmlFor="name" className='lb'>Tên nhiệm vụ</label>
      <TextField
        className='ip'
        fullWidth
        value={name}
        onChange={(e) => setName(e.target.value)}
        margin="normal"
      />

      <label htmlFor="description" className='lb'>Mô tả</label>
      <TextField
        className='ip'
        fullWidth
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        margin="normal"
      />

      <label htmlFor="priority" className='lb'>Độ ưu tiên</label>
      <FormControl fullWidth margin="normal">
        <Select
          labelId="priority-label"
          value={priority}
          onChange={(e) => setPriority(e.target.value)}
        className='ip'

        >
          <MenuItem value="Không ưu tiên">Không ưu tiên</MenuItem>
          <MenuItem value="Cao">Cao</MenuItem>
          <MenuItem value="Vừa">Vừa</MenuItem>
          <MenuItem value="Thấp">Thấp</MenuItem>
        </Select>
      </FormControl>

      <label htmlFor="status" className='lb'>Trạng thái</label>
      <FormControl fullWidth margin="normal">
        <Select
          labelId="status-label"
          value={status}
          onChange={(e) => setStatus(e.target.value)}
        className='ip'

        >
          <MenuItem value="Chưa hoàn thành">Chưa hoàn thành</MenuItem>
          <MenuItem value="Đã hoàn thành">Đã hoàn thành</MenuItem>
        </Select>
      </FormControl>

      <Button variant="contained" fullWidth color="primary" onClick={handleUpdate} style={{ marginTop: '20px' }}>
        Cập nhật
      </Button>
    </div>
  );
};

export default EditPage;
