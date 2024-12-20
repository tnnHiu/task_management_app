import React, { useEffect, useState } from 'react';
import { collection, getDocs, doc, deleteDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { useNavigate } from 'react-router-dom';
import { Button, Table, TableBody, TableCell, TableHead, TableRow, TextField, Select, MenuItem, FormControl, Drawer, IconButton, List, ListItem, ListItemText } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu'; // Import Menu Icon
import '../index.css';

const HomePage = () => {
  const [data, setData] = useState([]);
  const [filteredData, setFilteredData] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [filterPriority, setFilterPriority] = useState('');
  const [isSidebarOpen, setIsSidebarOpen] = useState(false); // State để quản lý Sidebar
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const tasksSnapshot = await getDocs(collection(db, 'tasks'));
        const tasks = tasksSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

        const usersSnapshot = await getDocs(collection(db, 'user'));
        const users = usersSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

        const tasksWithUsernames = tasks.map(task => {
          const user = users.find(user => user.id === task.userId);
          return {
            ...task,
            username: user ? user.username : 'Không xác định',
          };
        });

        setData(tasksWithUsernames);
        setFilteredData(tasksWithUsernames);
      } catch (error) {
        console.error("Lỗi khi tải dữ liệu:", error);
      }
    };

    fetchData();
  }, []);

  const toggleSidebar = (open) => {
    setIsSidebarOpen(open);
  };

  const handleSearch = (e) => {
    const value = e.target.value.toLowerCase();
    setSearchTerm(value);
    filterTasks(value, filterStatus, filterPriority);
  };

  const handleFilterStatus = (status) => {
    setFilterStatus(status);
    filterTasks(searchTerm, status, filterPriority);
  };

  const handleFilterPriority = (priority) => {
    setFilterPriority(priority);
    filterTasks(searchTerm, filterStatus, priority);
  };

  const filterTasks = (search, status, priority) => {
    let filtered = data;

    if (search) {
      filtered = filtered.filter(task => task.name.toLowerCase().includes(search));
    }
    if (status) {
      filtered = filtered.filter(task => task.status === status);
    }
    if (priority) {
      filtered = filtered.filter(task => task.priority === priority);
    }

    setFilteredData(filtered);
  };

  const handleDelete = async (taskId) => {
    const confirmDelete = window.confirm('Bạn có chắc chắn muốn xóa công việc này không?');
    if (!confirmDelete) return;

    try {
      await deleteDoc(doc(db, 'tasks', taskId));
      setData(prevData => prevData.filter(task => task.id !== taskId));
      setFilteredData(prevData => prevData.filter(task => task.id !== taskId));
      alert('Xóa công việc thành công!');
    } catch (error) {
      console.error('Lỗi khi xóa công việc:', error);
      alert('Xóa công việc thất bại!');
    }
  };

  return (
    <div className="container">
      <IconButton onClick={() => toggleSidebar(true)} style={{ color: 'white' }}>
        <MenuIcon />
      </IconButton>

      <Drawer anchor="left" open={isSidebarOpen} onClose={() => toggleSidebar(false)}>
        <List>
          <ListItem button onClick={() => navigate('/')}>
            <ListItemText primary="Trang chủ" />
          </ListItem>
          <ListItem button onClick={() => navigate('/event')}>
            <ListItemText primary="Sự kiện" />
          </ListItem>
          <ListItem button onClick={() => navigate('/user')}>
            <ListItemText primary="Người dùng" />
          </ListItem>
        </List>
      </Drawer>

      <h1 className="title">DANH SÁCH NHIỆM VỤ</h1>

      <div style={{ display: 'flex', gap: '20px', marginBottom: '20px' }}>
        <TextField
          placeholder="Tìm kiếm"
          fullWidth
          value={searchTerm}
          onChange={handleSearch}
          variant="outlined"
        />
        <FormControl fullWidth>
          <Select
            className="ip"
            value={filterStatus}
            onChange={(e) => handleFilterStatus(e.target.value)}
          >
            <MenuItem value="">Tất cả</MenuItem>
            <MenuItem value="Đã hoàn thành">Đã hoàn thành</MenuItem>
            <MenuItem value="Chưa hoàn thành">Chưa hoàn thành</MenuItem>
          </Select>
        </FormControl>
        <FormControl fullWidth>
          <Select
            className="ip"
            value={filterPriority}
            onChange={(e) => handleFilterPriority(e.target.value)}
          >
            <MenuItem value="">Tất cả</MenuItem>
            <MenuItem value="Cao">Cao</MenuItem>
            <MenuItem value="Vừa">Vừa</MenuItem>
            <MenuItem value="Thấp">Thấp</MenuItem>
            <MenuItem value="Không ưu tiên">Không ưu tiên</MenuItem>
          </Select>
        </FormControl>
      </div>

      <div className="table-container">
        <Table className="task-table">
          <TableHead className="table-head">
            <TableRow>
              <TableCell className="table-head-cell">Tên người dùng</TableCell>
              <TableCell className="table-head-cell">Tên nhiệm vụ</TableCell>
              <TableCell className="table-head-cell">Mô tả</TableCell>
              <TableCell className="table-head-cell">Độ ưu tiên</TableCell>
              <TableCell className="table-head-cell">Trạng thái</TableCell>
              <TableCell className="table-head-cell">Hành động</TableCell>
            </TableRow>
          </TableHead>
          <TableBody className="table-body">
            {filteredData.map(item => (
              <TableRow key={item.id}>
                <TableCell>{item.username}</TableCell>
                <TableCell>{item.name}</TableCell>
                <TableCell>{item.description}</TableCell>
                <TableCell>{item.priority}</TableCell>
                <TableCell>{item.status}</TableCell>
                <TableCell>
                  <Button 
                    variant="outlined" 
                    className="edit-button"
                    onClick={() => navigate(`/edit/${item.id}`)}
                  >
                    Sửa
                  </Button>
                  <Button 
                    variant="outlined" 
                    className="delete-button action-button" 
                    onClick={() => handleDelete(item.id)}
                  >
                    Xóa
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
};

export default HomePage;
