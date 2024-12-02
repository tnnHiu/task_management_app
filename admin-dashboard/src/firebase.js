import { initializeApp } from "firebase/app";
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyB8uvY858rOo4ziXhl17UcrE6f4aVS5jZ8",
  authDomain: "task-management-app-flut-68cdf.firebaseapp.com",
  projectId: "task-management-app-flut-68cdf",
  storageBucket: "task-management-app-flut-68cdf.firebasestorage.app",
  messagingSenderId: "11351257467",
  appId: "1:11351257467:web:236bae416bea30ed3c8dde",
  measurementId: "G-SET52FQ07Q"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { db };