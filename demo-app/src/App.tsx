import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useAuthStore } from './lib/store';
import AdminLayout from './components/AdminLayout';
import ThemeProvider from './components/ThemeProvider';

// Lazy load pages
const Dashboard = React.lazy(() => import('./pages/admin/Dashboard'));
const Properties = React.lazy(() => import('./pages/admin/Properties'));
const Maintenance = React.lazy(() => import('./pages/admin/Maintenance'));
const Tenants = React.lazy(() => import('./pages/admin/Tenants'));
const Contracts = React.lazy(() => import('./pages/admin/Contracts'));
const Bookings = React.lazy(() => import('./pages/admin/Bookings'));
const Departments = React.lazy(() => import('./pages/admin/Departments')); // Add this line
const Users = React.lazy(() => import('./pages/admin/Users'));
const Settings = React.lazy(() => import('./pages/admin/Settings'));
const Reports = React.lazy(() => import('./pages/admin/Reports'));
const Profile = React.lazy(() => import('./pages/admin/Profile'));
const Login = React.lazy(() => import('./pages/auth/Login'));

export default function App() {
  const { user, loading, initialize } = useAuthStore();

  React.useEffect(() => {
    initialize();
  }, [initialize]);

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <ThemeProvider>
      <BrowserRouter>
        <Routes>
          <Route
            path="/login"
            element={
              <React.Suspense fallback={<div>Loading...</div>}>
                {user ? <Navigate to="/admin/dashboard" replace /> : <Login />}
              </React.Suspense>
            }
          />
          <Route
            path="/admin"
            element={user ? <AdminLayout /> : <Navigate to="/login" replace />}
          >
            <Route index element={<Navigate to="/admin/dashboard" replace />} />
            <Route
              path="dashboard"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Dashboard />
                </React.Suspense>
              }
            />
            <Route
              path="properties/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Properties />
                </React.Suspense>
              }
            />
            <Route
              path="maintenance/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Maintenance />
                </React.Suspense>
              }
            />
            <Route
              path="tenants/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Tenants />
                </React.Suspense>
              }
            />
            <Route
              path="contracts/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Contracts />
                </React.Suspense>
              }
            />
            <Route
              path="bookings/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Bookings />
                </React.Suspense>
              }
            />
            <Route
              path="departments/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Departments />
                </React.Suspense>
              }
            />
            <Route
              path="reports"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Reports />
                </React.Suspense>
              }
            />
            <Route
              path="users/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Users />
                </React.Suspense>
              }
            />
            <Route
              path="settings/*"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Settings />
                </React.Suspense>
              }
            />
            <Route
              path="profile"
              element={
                <React.Suspense fallback={<div>Loading...</div>}>
                  <Profile />
                </React.Suspense>
              }
            />
          </Route>
          <Route path="*" element={<Navigate to="/admin/dashboard" replace />} />
        </Routes>
      </BrowserRouter>
    </ThemeProvider>
  );
}