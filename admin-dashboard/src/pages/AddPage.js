import React, { useState } from 'react';
import { collection, addDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { useNavigate } from 'react-router-dom';
import { Button, TextField } from '@mui/material';

const AddPage = () => {
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const navigate = useNavigate();

  const handleAdd = async () => {
    await addDoc(collection(db, 'tasks'), { name, description });
    navigate('/');
  };

  return (
    <div style={{ padding: '20px' }}>
      <h1>Thêm công việc</h1>
      <TextField
        fullWidth
        label="Tên công việc"
        value={name}
        onChange={(e) => setName(e.target.value)}
        margin="normal"
      />
      <TextField
        fullWidth
        label="Mô tả"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        margin="normal"
      />
      <Button variant="contained" color="primary" onClick={handleAdd}>
        Thêm
      </Button>
    </div>
  );
};

export default AddPage;
