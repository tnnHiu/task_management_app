import React, { useEffect, useState } from 'react';
import { collection, getDocs, addDoc, updateDoc, doc } from 'firebase/firestore';
import { db } from '../firebase';
import { Button, Table, TableBody, TableCell, TableHead, TableRow, TextField, Dialog, DialogTitle, DialogContent, DialogActions } from '@mui/material';
import '../index.css'

const UserPage = () => {
  const [users, setUsers] = useState([]);
  const [openDialog, setOpenDialog] = useState(false);
  const [editUser, setEditUser] = useState(null);
  const [formData, setFormData] = useState({ name: '', email: '' });

  // Lấy danh sách người dùng từ Firestore
  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const userSnapshot = await getDocs(collection(db, 'user'));
        const userList = userSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setUsers(userList);
      } catch (error) {
        console.error('Lỗi khi tải danh sách người dùng:', error);
      }
    };
    fetchUsers();
  }, []);

  // Mở hộp thoại
  const handleOpenDialog = (user = null) => {
    setEditUser(user);
    setFormData(user ? { name: user.name, email: user.email } : { name: '', email: '' });
    setOpenDialog(true);
  };

  // Đóng hộp thoại
  const handleCloseDialog = () => {
    setOpenDialog(false);
    setEditUser(null);
    setFormData({ name: '', email: '' });
  };

  // Xử lý thêm hoặc chỉnh sửa người dùng
  const handleSubmit = async () => {
    if (!formData.name || !formData.email) {
      alert('Vui lòng nhập đầy đủ thông tin!');
      return;
    }

    try {
      if (editUser) {
        // Cập nhật thông tin người dùng
        const userRef = doc(db, 'user', editUser.id);
        await updateDoc(userRef, formData);
        setUsers(prevUsers => prevUsers.map(user => (user.id === editUser.id ? { ...user, ...formData } : user)));
        alert('Cập nhật thông tin thành công!');
      } else {
        // Thêm người dùng mới
        const newUser = await addDoc(collection(db, 'user'), formData);
        setUsers(prevUsers => [...prevUsers, { id: newUser.id, ...formData }]);
        alert('Thêm người dùng mới thành công!');
      }
    } catch (error) {
      console.error('Lỗi khi lưu thông tin người dùng:', error);
      alert('Lưu thông tin thất bại!');
    }

    handleCloseDialog();
  };

  return (
    <div className="container">
      <h1 className="title">DANH SÁCH NGƯỜI DÙNG</h1>
      <Button variant="contained" color="primary" onClick={() => handleOpenDialog()}>
        Thêm Người Dùng Mới
      </Button>
      <div className="table-container" style={{ marginTop: '20px' }}>
        <Table className="task-table">
          <TableHead className="table-head">
            <TableRow>
              <TableCell  className="table-head-cell">Tên</TableCell>
              <TableCell  className="table-head-cell">Email</TableCell>
              <TableCell  className="table-head-cell">Hành động</TableCell>
            </TableRow>
          </TableHead>
          <TableBody className="table-body">
            {users.map(user => (
              <TableRow key={user.id}>
                <TableCell>{user.username}</TableCell>
                <TableCell>{user.email}</TableCell>
                <TableCell>
                  <Button
                    variant="outlined"
                    color="primary"
                    onClick={() => handleOpenDialog(user)}
                  >
                    Chỉnh sửa
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {/* Dialog thêm/chỉnh sửa người dùng */}
      <Dialog open={openDialog} onClose={handleCloseDialog}>
        <DialogTitle>{editUser ? 'Chỉnh sửa người dùng' : 'Thêm người dùng mới'}</DialogTitle>
        <DialogContent>
          <TextField
            label="Tên"
            fullWidth
            margin="normal"
            value={formData.name}
            onChange={e => setFormData({ ...formData, name: e.target.value })}
          />
          <TextField
            label="Email"
            fullWidth
            margin="normal"
            value={formData.email}
            onChange={e => setFormData({ ...formData, email: e.target.value })}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Hủy</Button>
          <Button variant="contained" color="primary" onClick={handleSubmit}>
            {editUser ? 'Lưu' : 'Thêm'}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default UserPage;
