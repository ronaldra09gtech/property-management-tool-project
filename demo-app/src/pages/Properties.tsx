import React from 'react';
import { Building2, Plus } from 'lucide-react';

const properties = [
  {
    id: '1',
    name: 'Sunset Apartments',
    address: '123 Sunset Blvd, Los Angeles, CA 90028',
    units: 24,
    occupancyRate: 92,
    imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=400',
  },
  {
    id: '2',
    name: 'Ocean View Complex',
    address: '456 Ocean Ave, Santa Monica, CA 90401',
    units: 36,
    occupancyRate: 88,
    imageUrl: 'https://images.unsplash.com/photo-1460317442991-0ec209397118?auto=format&fit=crop&w=400',
  },
  // Add more properties as needed
];

export default function Properties() {
  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">Properties</h1>
        <button className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700">
          <Plus className="h-5 w-5 mr-2" />
          Add Property
        </button>
      </div>

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {properties.map((property) => (
          <div
            key={property.id}
            className="bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow duration-200"
          >
            <div className="relative h-48">
              <img
                src={property.imageUrl}
                alt={property.name}
                className="w-full h-full object-cover rounded-t-lg"
              />
            </div>
            <div className="p-4">
              <div className="flex items-center justify-between">
                <h3 className="text-lg font-medium text-gray-900">{property.name}</h3>
                <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  {property.occupancyRate}% Occupied
                </span>
              </div>
              <p className="mt-1 text-sm text-gray-500">{property.address}</p>
              <div className="mt-4 flex items-center justify-between">
                <div className="flex items-center text-sm text-gray-500">
                  <Building2 className="h-5 w-5 mr-1" />
                  {property.units} Units
                </div>
                <button className="text-sm font-medium text-indigo-600 hover:text-indigo-500">
                  View Details
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}