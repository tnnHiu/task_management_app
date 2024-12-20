import React, { useEffect, useState } from 'react';
import { collection, getDocs, doc, deleteDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { useNavigate } from 'react-router-dom';
import { Button, Table, TableBody, TableCell, TableHead, TableRow, TextField, Drawer, IconButton, List, ListItem, ListItemText } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import '../index.css';

const HomePage = () => {
  const [data, setData] = useState([]);
  const [filteredData, setFilteredData] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [sortConfig, setSortConfig] = useState({ key: null, direction: 'asc' });
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const eventsSnapshot = await getDocs(collection(db, 'events'));
        const events = eventsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

        const usersSnapshot = await getDocs(collection(db, 'user'));
        const users = usersSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

        const eventsWithUsernames = events.map(event => {
          const user = users.find(user => user.id === event.userId);
          return {
            ...event,
            username: user ? user.username : 'Không xác định',
          };
        });

        setData(eventsWithUsernames);
        setFilteredData(eventsWithUsernames);
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
    SearchRs(value);
  };

  const SearchRs = (search) => {
    let filtered = data;

    if (search) {
      filtered = filtered.filter(event => event.title.toLowerCase().includes(search));
    }

    setFilteredData(filtered);
  };

  const handleSort = (key) => {
    let direction = 'asc';
    if (sortConfig.key === key && sortConfig.direction === 'asc') {
      direction = 'desc';
    }
    setSortConfig({ key, direction });
  
    const sortedData = [...filteredData].sort((a, b) => {
      if (key === 'startTime' || key === 'endTime') {
        // Chuyển đổi Timestamp của Firebase thành Date
        const dateA = a[key].toDate();
        const dateB = b[key].toDate();
  
        return direction === 'asc'
          ? dateA - dateB
          : dateB - dateA;
      }
  
      if (a[key] < b[key]) {
        return direction === 'asc' ? -1 : 1;
      }
      if (a[key] > b[key]) {
        return direction === 'asc' ? 1 : -1;
      }
      return 0;
    });
  
    setFilteredData(sortedData);
  };
  

  const handleDelete = async (eventId) => {
    const confirmDelete = window.confirm('Bạn có chắc chắn muốn xóa công việc này không?');
    if (!confirmDelete) return;

    try {
      await deleteDoc(doc(db, 'events', eventId));
      setData(prevData => prevData.filter(task => task.id !== eventId));
      setFilteredData(prevData => prevData.filter(task => task.id !== eventId));
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
          <ListItem button onClick={() => navigate('/events')}>
            <ListItemText primary="Sự kiện" />
          </ListItem>
          <ListItem button onClick={() => navigate('/user')}>
            <ListItemText primary="Người dùng" />
          </ListItem>
        </List>
      </Drawer>

      <h1 className="title">DANH SÁCH SỰ KIỆN</h1>

      <div style={{ display: 'flex', gap: '20px', marginBottom: '20px' }}>
        <TextField
          placeholder="Tìm kiếm"
          fullWidth
          value={searchTerm}
          onChange={handleSearch}
          variant="outlined"
        />
      </div>

      <div className="table-container">
        <Table className="task-table">
          <TableHead className="table-head">
            <TableRow>
              <TableCell className="table-head-cell" onClick={() => handleSort('username')}>
                Tên người dùng
              </TableCell>
              <TableCell className="table-head-cell">Tiêu đề</TableCell>
              <TableCell className="table-head-cell">Mô tả</TableCell>
              <TableCell className="table-head-cell">Địa điểm</TableCell>
              <TableCell className="table-head-cell" onClick={() => handleSort('startTime')}>
                Thời gian bắt đầu
              </TableCell>
              <TableCell className="table-head-cell" onClick={() => handleSort('endTime')}>
                Thời gian kết thúc
              </TableCell>
              <TableCell className="table-head-cell">Hành động</TableCell>
            </TableRow>
          </TableHead>
          <TableBody className="table-body">
            {filteredData.map(item => (
              <TableRow key={item.id}>
                <TableCell>{item.username}</TableCell>
                <TableCell>{item.title}</TableCell>
                <TableCell>{item.description}</TableCell>
                <TableCell>{item.location}</TableCell>
                <TableCell>{item.startTime.toDate().toLocaleString()}</TableCell>
                <TableCell>{item.endTime.toDate().toLocaleString()}</TableCell>
                <TableCell>
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
