import React from 'react';
import { BarChart2, TrendingUp, Users, Building2, Wallet, AlertTriangle } from 'lucide-react';
import { formatCurrency } from '../../lib/utils';

const stats = [
  {
    name: 'Total Revenue',
    value: formatCurrency(124500),
    change: '+12.5%',
    trend: 'up',
    icon: Wallet,
  },
  {
    name: 'Total Properties',
    value: '45',
    change: '+2',
    trend: 'up',
    icon: Building2,
  },
  {
    name: 'Active Tenants',
    value: '156',
    change: '+8.2%',
    trend: 'up',
    icon: Users,
  },
  {
    name: 'Maintenance Requests',
    value: '12',
    change: '-2',
    trend: 'down',
    icon: AlertTriangle,
  },
];

export default function Dashboard() {
  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">Dashboard</h1>
        <div className="flex space-x-3">
          <button className="inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
            <BarChart2 className="h-5 w-5 mr-2 text-gray-500" />
            Generate Report
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        {stats.map((item) => (
          <div
            key={item.name}
            className="relative bg-white pt-5 px-4 pb-12 sm:pt-6 sm:px-6 rounded-lg overflow-hidden shadow"
          >
            <dt>
              <div className="absolute bg-indigo-500 rounded-md p-3">
                <item.icon className="h-6 w-6 text-white" />
              </div>
              <p className="ml-16 text-sm font-medium text-gray-500 truncate">{item.name}</p>
            </dt>
            <dd className="ml-16 pb-6 flex items-baseline sm:pb-7">
              <p className="text-2xl font-semibold text-gray-900">{item.value}</p>
              <p
                className={`ml-2 flex items-baseline text-sm font-semibold ${
                  item.trend === 'up' ? 'text-green-600' : 'text-red-600'
                }`}
              >
                <TrendingUp
                  className={`self-center flex-shrink-0 h-5 w-5 ${
                    item.trend === 'up'
                      ? 'text-green-500 rotate-0'
                      : 'text-red-500 rotate-180'
                  }`}
                  aria-hidden="true"
                />
                <span className="ml-1">{item.change}</span>
              </p>
            </dd>
          </div>
        ))}
      </div>

      <div className="mt-8 grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Revenue Chart */}
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Revenue Overview</h3>
          <div className="h-80 flex items-center justify-center border-2 border-dashed border-gray-200 rounded-lg">
            <p className="text-gray-500">Revenue chart will be implemented here</p>
          </div>
        </div>

        {/* Recent Activity */}
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Recent Activity</h3>
          <div className="flow-root">
            <ul role="list" className="-mb-8">
              {[1, 2, 3, 4, 5].map((item) => (
                <li key={item}>
                  <div className="relative pb-8">
                    <span
                      className="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-200"
                      aria-hidden="true"
                    />
                    <div className="relative flex space-x-3">
                      <div>
                        <span className="h-8 w-8 rounded-full bg-blue-500 flex items-center justify-center ring-8 ring-white">
                          <Users className="h-5 w-5 text-white" />
                        </span>
                      </div>
                      <div className="min-w-0 flex-1 pt-1.5 flex justify-between space-x-4">
                        <div>
                          <p className="text-sm text-gray-500">
                            New tenant signed lease for <span className="font-medium text-gray-900">Unit 204</span>
                          </p>
                        </div>
                        <div className="text-right text-sm whitespace-nowrap text-gray-500">
                          2h ago
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}