import React from 'react';
import { Link, Outlet, useLocation, useNavigate } from 'react-router-dom';
import {
  Building2,
  ClipboardList,
  Users,
  Settings,
  Bell,
  Menu,
  BarChart2,
  FileText,
  Calendar,
  UserCog,
  PieChart,
  X,
  Search,
  ChevronDown,
  User,
  Briefcase,
} from 'lucide-react';
import { useAuthStore } from '../lib/store';

const navigation = [
  { name: 'Dashboard', href: '/admin/dashboard', icon: BarChart2 },
  { name: 'Properties', href: '/admin/properties', icon: Building2 },
  { name: 'Maintenance', href: '/admin/maintenance', icon: ClipboardList },
  { name: 'Tenants', href: '/admin/tenants', icon: Users },
  { name: 'Contracts', href: '/admin/contracts', icon: FileText },
  { name: 'Bookings', href: '/admin/bookings', icon: Calendar },
  { name: 'Departments', href: '/admin/departments', icon: Briefcase },
  { name: 'Reports', href: '/admin/reports', icon: PieChart },
  { name: 'Users', href: '/admin/users', icon: UserCog },
  { name: 'Settings', href: '/admin/settings', icon: Settings },
];

const NavLink = ({ item, isMobile = false }: { item: typeof navigation[0], isMobile?: boolean }) => {
  const location = useLocation();
  const isActive = location.pathname.startsWith(item.href);
  return (
    <Link
      key={item.name}
      to={item.href}
      className={`${
        isActive
          ? 'bg-indigo-50 text-indigo-600'
          : 'text-gray-600 hover:bg-gray-50'
      } group flex items-center px-2 py-2 text-sm font-medium rounded-md ${
        isMobile ? 'text-base' : ''
      }`}
    >
      <item.icon
        className={`${
          isActive ? 'text-indigo-600' : 'text-gray-400 group-hover:text-gray-500'
        } mr-3 flex-shrink-0 h-6 w-6`}
      />
      {item.name}
    </Link>
  );
};

export default function AdminLayout() {
  const location = useLocation();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = React.useState(false);
  const [searchOpen, setSearchOpen] = React.useState(false);
  const [userMenuOpen, setUserMenuOpen] = React.useState(false);
  const searchRef = React.useRef<HTMLDivElement>(null);
  const { user, signOut } = useAuthStore();

  React.useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (searchRef.current && !searchRef.current.contains(event.target as Node)) {
        setSearchOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  React.useEffect(() => {
    setSidebarOpen(false);
  }, [location]);

  return (
    <div className="min-h-screen bg-gray-50">
      <div
        className={`fixed inset-0 z-40 bg-gray-600 bg-opacity-75 transition-opacity duration-300 ease-linear lg:hidden ${
          sidebarOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'
        }`}
        onClick={() => setSidebarOpen(false)}
      />

      <div
        className={`fixed inset-0 z-30 bg-gray-600 bg-opacity-75 transition-opacity duration-300 ease-linear lg:hidden ${
          searchOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'
        }`}
        onClick={() => setSearchOpen(false)}
      />

      <div
        className={`fixed inset-y-0 left-0 z-50 w-full max-w-xs bg-white transform transition duration-300 ease-in-out lg:hidden ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex flex-col h-full">
          <div className="flex items-center justify-between px-4 py-3 border-b border-gray-200">
            <div className="flex items-center">
              <Building2 className="h-8 w-8 text-indigo-600" />
              <span className="ml-2 text-xl font-bold text-gray-900">PropManager</span>
            </div>
            <button
              onClick={() => setSidebarOpen(false)}
              className="text-gray-500 hover:text-gray-700"
            >
              <X className="h-6 w-6" />
            </button>
          </div>

          <nav className="flex-1 px-2 py-4 overflow-y-auto">
            {navigation.map((item) => (
              <NavLink key={item.href} item={item} isMobile />
            ))}
          </nav>

          <div className="border-t border-gray-200 p-4">
            <div className="flex items-center">
              <img
                className="h-9 w-9 rounded-full"
                src={`https://ui-avatars.com/api/?name=${user?.email}&background=random`}
                alt=""
              />
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-700">{user?.email}</p>
                <div className="flex space-x-4">
                  <button
                    onClick={() => navigate('/admin/profile')}
                    className="text-xs font-medium text-gray-500 hover:text-gray-700"
                  >
                    Profile
                  </button>
                  <button
                    onClick={() => signOut()}
                    className="text-xs font-medium text-gray-500 hover:text-gray-700"
                  >
                    Sign out
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="hidden lg:flex lg:w-64 lg:flex-col lg:fixed lg:inset-y-0">
        <div className="flex-1 flex flex-col min-h-0 bg-white border-r border-gray-200">
          <div className="flex-1 flex flex-col pt-5 pb-4 overflow-y-auto">
            <div className="flex items-center flex-shrink-0 px-4">
              <Building2 className="h-8 w-8 text-indigo-600" />
              <span className="ml-2 text-xl font-bold text-gray-900">PropManager</span>
            </div>
            <nav className="mt-5 flex-1 px-2 space-y-1">
              {navigation.map((item) => (
                <NavLink key={item.href} item={item} />
              ))}
            </nav>
          </div>
          <div className="flex-shrink-0 flex border-t border-gray-200 p-4">
            <div className="flex items-center w-full">
              <div className="flex-shrink-0">
                <img
                  className="h-9 w-9 rounded-full"
                  src={`https://ui-avatars.com/api/?name=${user?.email}&background=random`}
                  alt=""
                />
              </div>
              <div className="ml-3 min-w-0 flex-1">
                <p className="text-sm font-medium text-gray-700 truncate">{user?.email}</p>
                <div className="flex space-x-4">
                  <button
                    onClick={() => navigate('/admin/profile')}
                    className="text-xs font-medium text-gray-500 hover:text-gray-700"
                  >
                    Profile
                  </button>
                  <button
                    onClick={() => signOut()}
                    className="text-xs font-medium text-gray-500 hover:text-gray-700"
                  >
                    Sign out
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="lg:pl-64 flex flex-col flex-1">
        <div className="sticky top-0 z-10 flex-shrink-0 flex h-16 bg-white border-b border-gray-200">
          <button
            type="button"
            className="px-4 border-r border-gray-200 text-gray-500 lg:hidden"
            onClick={() => setSidebarOpen(true)}
          >
            <span className="sr-only">Open sidebar</span>
            <Menu className="h-6 w-6" />
          </button>

          <div className="flex-1 px-4 flex justify-between">
            <div className="flex-1 flex items-center" ref={searchRef}>
              <button
                className="lg:hidden p-2 -ml-2 text-gray-400 hover:text-gray-500"
                onClick={() => setSearchOpen(!searchOpen)}
              >
                <Search className="h-5 w-5" />
              </button>

              <div
                className={`absolute top-0 left-0 right-0 p-4 bg-white transform transition-all duration-300 ease-in-out lg:hidden ${
                  searchOpen
                    ? 'translate-y-0 opacity-100'
                    : '-translate-y-full opacity-0 pointer-events-none'
                }`}
              >
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                  <input
                    type="text"
                    placeholder="Search..."
                    className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  />
                  <button
                    className="absolute right-3 top-1/2 transform -translate-y-1/2"
                    onClick={() => setSearchOpen(false)}
                  >
                    <X className="h-5 w-5 text-gray-400" />
                  </button>
                </div>
              </div>

              <div className="hidden lg:flex w-full max-w-2xl">
                <div className="w-full">
                  <label htmlFor="search" className="sr-only">
                    Search
                  </label>
                  <div className="relative">
                    <div className="pointer-events-none absolute inset-y-0 left-0 pl-3 flex items-center">
                      <Search className="h-5 w-5 text-gray-400" />
                    </div>
                    <input
                      id="search"
                      type="search"
                      placeholder="Search..."
                      className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="ml-4 flex items-center md:ml-6">
              <button className="p-1 rounded-full text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                <span className="sr-only">View notifications</span>
                <Bell className="h-6 w-6" />
              </button>

              <div className="ml-3 relative">
                <div>
                  <button
                    onClick={() => setUserMenuOpen(!userMenuOpen)}
                    className="max-w-xs flex items-center text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 lg:p-2 lg:rounded-md"
                  >
                    <img
                      className="h-8 w-8 rounded-full"
                      src={`https://ui-avatars.com/api/?name=${user?.email}&background=random`}
                      alt=""
                    />
                    <span className="hidden ml-3 text-gray-700 text-sm font-medium lg:block">
                      <span className="sr-only">Open user menu for </span>
                      {user?.email}
                    </span>
                    <ChevronDown className="hidden flex-shrink-0 ml-1 h-5 w-5 text-gray-400 lg:block" />
                  </button>
                </div>
                {userMenuOpen && (
                  <div className="origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5">
                    <button
                      onClick={() => {
                        navigate('/admin/profile');
                        setUserMenuOpen(false);
                      }}
                      className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    >
                      <div className="flex items-center">
                        <User className="h-4 w-4 mr-2" />
                        Profile
                      </div>
                    </button>
                    <button
                      onClick={() => {
                        signOut();
                        setUserMenuOpen(false);
                      }}
                      className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    >
                      Sign out
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>

        <main className="flex-1">
          <div className="py-6">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 md:px-8">
              <Outlet />
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}