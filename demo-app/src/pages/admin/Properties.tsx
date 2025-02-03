import React from 'react';
import { Building2, Plus, Users, DollarSign, Mail, Phone, X, Camera, Upload } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getProperties, createProperty } from '../../lib/api/properties';
import type { Property } from '../../types';

export default function Properties() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [isAddModalOpen, setIsAddModalOpen] = React.useState(false);
  const [isDetailsModalOpen, setIsDetailsModalOpen] = React.useState(false);
  const [selectedProperty, setSelectedProperty] = React.useState<Property | null>(null);
  const [newProperty, setNewProperty] = React.useState({
    name: '',
    address: '',
    units: '',
    owner: {
      name: '',
      email: '',
      phone: '',
    },
    propertyManager: {
      name: '',
      email: '',
      phone: '',
    },
  });

  // Fetch properties
  const { data: properties, isLoading, error } = useQuery({
    queryKey: ['properties'],
    queryFn: getProperties,
  });

  // Create property mutation
  const createPropertyMutation = useMutation({
    mutationFn: createProperty,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['properties'] });
      setIsAddModalOpen(false);
      setNewProperty({
        name: '',
        address: '',
        units: '',
        owner: { name: '', email: '', phone: '' },
        propertyManager: { name: '', email: '', phone: '' },
      });
    },
  });

  const handleAddProperty = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await createPropertyMutation.mutateAsync({
        name: newProperty.name,
        address: newProperty.address,
        units: parseInt(newProperty.units),
        status: 'active',
        owner: {
          name: newProperty.owner.name,
          email: newProperty.owner.email,
          phone: newProperty.owner.phone,
          role: 'owner',
        },
        propertyManager: {
          name: newProperty.propertyManager.name,
          email: newProperty.propertyManager.email,
          phone: newProperty.propertyManager.phone,
          role: 'manager',
        },
      });
    } catch (error) {
      console.error('Error creating property:', error);
    }
  };

  const handleViewDetails = (property: Property) => {
    setSelectedProperty(property);
    setIsDetailsModalOpen(true);
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="text-red-600">Error loading properties. Please try again later.</div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 sm:gap-0">
        <h1 className="text-2xl font-semibold text-gray-900">Properties</h1>
        <button
          onClick={() => setIsAddModalOpen(true)}
          className="w-full sm:w-auto inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700"
        >
          <Plus className="h-5 w-5 mr-2" />
          Add Property
        </button>
      </div>

      {/* No Properties Message */}
      {properties?.length === 0 ? (
        <div className="flex flex-col items-center justify-center h-96 bg-white rounded-lg shadow-sm p-8">
          <Building2 className="h-16 w-16 text-gray-400 mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">No Properties Added</h3>
          <p className="text-gray-500 text-center mb-6">
            Get started by adding your first property to manage.
          </p>
          <button
            onClick={() => setIsAddModalOpen(true)}
            className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700"
          >
            <Plus className="h-5 w-5 mr-2" />
            Add Your First Property
          </button>
        </div>
      ) : (
        /* Property Grid */
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
          {properties?.map((property) => (
            <div
              key={property.id}
              className="bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow duration-200 overflow-hidden"
            >
              <div className="relative h-48">
                <img
                  src={property.imageUrl}
                  alt={property.name}
                  className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />
                <div className="absolute bottom-4 left-4 right-4">
                  <h3 className="text-lg font-medium text-white">{property.name}</h3>
                  <p className="mt-1 text-sm text-gray-200">{property.address}</p>
                </div>
              </div>
              
              <div className="p-4">
                <div className="grid grid-cols-2 gap-4 mb-4">
                  <div className="flex items-center">
                    <Building2 className="h-5 w-5 text-gray-400 mr-2" />
                    <span className="text-sm text-gray-600">{property.units} Units</span>
                  </div>
                  <div className="flex items-center">
                    <Users className="h-5 w-5 text-gray-400 mr-2" />
                    <span className="text-sm text-gray-600">{property.occupancyRate}% Occupied</span>
                  </div>
                  <div className="flex items-center col-span-2">
                    <DollarSign className="h-5 w-5 text-gray-400 mr-2" />
                    <span className="text-sm text-gray-600">${property.revenue.toLocaleString()}/mo</span>
                  </div>
                </div>

                <div className="border-t border-gray-200 pt-4">
                  <div className="space-y-4">
                    {/* Property Owner */}
                    <div>
                      <h4 className="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2">
                        Property Owner
                      </h4>
                      <div className="flex items-start">
                        <img
                          src={property.owner.imageUrl}
                          alt={property.owner.name}
                          className="h-10 w-10 rounded-full"
                        />
                        <div className="ml-3">
                          <p className="text-sm font-medium text-gray-900">{property.owner.name}</p>
                          <div className="mt-1 flex items-center space-x-4 text-sm text-gray-500">
                            <a href={`mailto:${property.owner.email}`} className="flex items-center hover:text-gray-700">
                              <Mail className="h-4 w-4 mr-1" />
                              <span>Email</span>
                            </a>
                            <a href={`tel:${property.owner.phone}`} className="flex items-center hover:text-gray-700">
                              <Phone className="h-4 w-4 mr-1" />
                              <span>Call</span>
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>

                    {/* Property Manager */}
                    <div>
                      <h4 className="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2">
                        Property Manager
                      </h4>
                      <div className="flex items-start">
                        <img
                          src={property.propertyManager.imageUrl}
                          alt={property.propertyManager.name}
                          className="h-10 w-10 rounded-full"
                        />
                        <div className="ml-3">
                          <p className="text-sm font-medium text-gray-900">{property.propertyManager.name}</p>
                          <div className="mt-1 flex items-center space-x-4 text-sm text-gray-500">
                            <a href={`mailto:${property.propertyManager.email}`} className="flex items-center hover:text-gray-700">
                              <Mail className="h-4 w-4 mr-1" />
                              <span>Email</span>
                            </a>
                            <a href={`tel:${property.propertyManager.phone}`} className="flex items-center hover:text-gray-700">
                              <Phone className="h-4 w-4 mr-1" />
                              <span>Call</span>
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="mt-4 flex justify-end">
                  <button
                    onClick={() => handleViewDetails(property)}
                    className="text-sm font-medium text-indigo-600 hover:text-indigo-500"
                  >
                    View Details
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Add Property Modal */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 overflow-y-auto">
          <div className="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div className="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />

            <div className="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
              <div className="absolute top-0 right-0 pt-4 pr-4">
                <button
                  onClick={() => setIsAddModalOpen(false)}
                  className="bg-white rounded-md text-gray-400 hover:text-gray-500"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>

              <div className="sm:flex sm:items-start">
                <div className="mt-3 text-center sm:mt-0 sm:text-left w-full">
                  <h3 className="text-lg leading-6 font-medium text-gray-900">Add New Property</h3>
                  <form onSubmit={handleAddProperty} className="mt-6 space-y-6">
                    <div className="space-y-4">
                      <div>
                        <label htmlFor="propertyImage" className="block text-sm font-medium text-gray-700">
                          Property Image
                        </label>
                        <div className="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
                          <div className="space-y-1 text-center">
                            <Camera className="mx-auto h-12 w-12 text-gray-400" />
                            <div className="flex text-sm text-gray-600">
                              <label
                                htmlFor="file-upload"
                                className="relative cursor-pointer bg-white rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500"
                              >
                                <span>Upload a file</span>
                                <input id="file-upload" name="file-upload" type="file" className="sr-only" />
                              </label>
                              <p className="pl-1">or drag and drop</p>
                            </div>
                            <p className="text-xs text-gray-500">PNG, JPG, GIF up to 10MB</p>
                          </div>
                        </div>
                      </div>

                      <div>
                        <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                          Property Name
                        </label>
                        <input
                          type="text"
                          name="name"
                          id="name"
                          value={newProperty.name}
                          onChange={(e) => setNewProperty({ ...newProperty, name: e.target.value })}
                          className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                        />
                      </div>

                      <div>
                        <label htmlFor="address" className="block text-sm font-medium text-gray-700">
                          Address
                        </label>
                        <input
                          type="text"
                          name="address"
                          id="address"
                          value={newProperty.address}
                          onChange={(e) => setNewProperty({ ...newProperty, address: e.target.value })}
                          className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                        />
                      </div>

                      <div>
                        <label htmlFor="units" className="block text-sm font-medium text-gray-700">
                          Number of Units
                        </label>
                        <input
                          type="number"
                          name="units"
                          id="units"
                          value={newProperty.units}
                          onChange={(e) => setNewProperty({ ...newProperty, units: e.target.value })}
                          className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                        />
                      </div>

                      <div className="border-t border-gray-200 pt-4">
                        <h4 className="text-sm font-medium text-gray-900">Property Owner</h4>
                        <div className="mt-4 grid grid-cols-1 gap-4">
                          <div>
                            <label htmlFor="ownerName" className="block text-sm font-medium text-gray-700">
                              Name
                            </label>
                            <input
                              type="text"
                              name="ownerName"
                              id="ownerName"
                              value={newProperty.owner.name}
                              onChange={(e) =>
                                setNewProperty({
                                  ...newProperty,
                                  owner: { ...newProperty.owner, name: e.target.value },
                                })
                              }
                              className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            />
                          </div>
                          <div>
                            <label htmlFor="ownerEmail" className="block text-sm font-medium text-gray-700">
                              Email
                            </label>
                            <input
                              type="email"
                              name="ownerEmail"
                              id="ownerEmail"
                              value={newProperty.owner.email}
                              onChange={(e) =>
                                setNewProperty({
                                  ...newProperty,
                                  owner: { ...newProperty.owner, email: e.target.value },
                                })
                              }
                              className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            />
                          </div>
                          <div>
                            <label htmlFor="ownerPhone" className="block text-sm font-medium text-gray-700">
                              Phone
                            </label>
                            <input
                              type="tel"
                              name="ownerPhone"
                              id="ownerPhone"
                              value={newProperty.owner.phone}
                              onChange={(e) =>
                                setNewProperty({
                                  ...newProperty,
                                  owner: { ...newProperty.owner, phone: e.target.value },
                                })
                              }
                              className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            />
                          </div>
                        </div>
                      </div>

                      <div className="border-t border-gray-200 pt-4">
                        <h4 className="text-sm font-medium text-gray-900">Property Manager</h4>
                        <div className="mt-4 grid grid-cols-1 gap-4">
                          <div>
                            <label htmlFor="managerName" className="block text-sm font-medium text-gray-700">
                              Name
                            </label>
                            <input
                              type="text"
                              name="managerName"
                              id="managerName"
                              value={newProperty.propertyManager.name}
                              onChange={(e) =>
                                setNewProperty({
                                  ...newProperty,
                                  propertyManager: { ...newProperty.propertyManager, name: e.target.value },
                                })
                              }
                              className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            />
                          </div>
                          <div>
                            <label htmlFor="managerEmail" className="block text-sm font-medium text-gray-700">
                              Email
                            </label>
                            <input
                              type="email"
                              name="managerEmail"
                              id="managerEmail"
                              value={newProperty.propertyManager.email}
                              onChange={(e) =>
                                setNewProperty({
                                  ...newProperty,
                                  propertyManager: { ...newProperty.propertyManager, email: e.target.value },
                                })
                              }
                              className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            />
                          </div>
                          <div>
                            <label htmlFor="managerPhone" className="block text-sm font-medium text-gray-700">
                              Phone
                            </label>
                            <input
                              type="tel"
                              name="managerPhone"
                              id="managerPhone"
                              value={newProperty.propertyManager.phone}
                              onChange={(e) =>
                                setNewProperty({
                                  ...newProperty,
                                  propertyManager: { ...newProperty.propertyManager, phone: e.target.value },
                                })
                              }
                              className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            />
                          </div>
                        </div>
                      </div>
                    </div>

                    <div className="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
                      <button
                        type="submit"
                        className="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:ml-3 sm:w-auto sm:text-sm"
                      >
                        Add Property
                      </button>
                      <button
                        type="button"
                        onClick={() => setIsAddModalOpen(false)}
                        className="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm"
                      >
                        Cancel
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Property Details Modal */}
      {isDetailsModalOpen && selectedProperty && (
        <div className="fixed inset-0 z-50 overflow-y-auto">
          <div className="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div className="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />

            <div className="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full sm:p-6">
              <div className="absolute top-0 right-0 pt-4 pr-4">
                <button
                  onClick={() => setIsDetailsModalOpen(false)}
                  className="bg-white rounded-md text-gray-400 hover:text-gray-500"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>

              <div>
                <div className="mt-3 text-center sm:mt-0 sm:text-left">
                  <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
                    Property Details
                  </h3>

                  <div className="relative h-64 rounded-lg overflow-hidden mb-6">
                    <img
                      src={selectedProperty.imageUrl}
                      alt={selectedProperty.name}
                      className="w-full h-full object-cover"
                    />
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <h4 className="text-sm font-medium text-gray-900 mb-2">Property Information</h4>
                      <dl className="space-y-2">
                        <div>
                          <dt className="text-sm font-medium text-gray-500">Name</dt>
                          <dd className="mt-1 text-sm text-gray-900">{selectedProperty.name}</dd>
                        </div>
                        <div>
                          <dt className="text-sm font-medium text-gray-500">Address</dt>
                          <dd className="mt-1 text-sm text-gray-900">{selectedProperty.address}</dd>
                        </div>
                        <div>
                          <dt className="text-sm font-medium text-gray-500">Units</dt>
                          <dd className="mt-1 text-sm text-gray-900">{selectedProperty.units}</dd>
                        </div>
                        <div>
                          <dt className="text-sm font-medium text-gray-500">Occupancy Rate</dt>
                          <dd className="mt-1 text-sm text-gray-900">{selectedProperty.occupancyRate}%</dd>
                        </div>
                        <div>
                          <dt className="text-sm font-medium text-gray-500">Monthly Revenue</dt>
                          <dd className="mt-1 text-sm text-gray-900">
                            ${selectedProperty.revenue.toLocaleString()}
                          </dd>
                        </div>
                      </dl>
                    </div>

                    <div>
                      <h4 className="text-sm font-medium text-gray-900 mb-2">Contact Information</h4>
                      <div className="space-y-4">
                        <div>
                          <h5 className="text-sm font-medium text-gray-500">Property Owner</h5>
                          <div className="mt-2">
                            <p className="text-sm text-gray-900">{selectedProperty.owner.name}</p>
                            <p className="text-sm text-gray-500">{selectedProperty.owner.email}</p>
                            <p className="text-sm text-gray-500">{selectedProperty.owner.phone}</p>
                          </div>
                        </div>
                        <div>
                          <h5 className="text-sm font-medium text-gray-500">Property Manager</h5>
                          <div className="mt-2">
                            <p className="text-sm text-gray-900">{selectedProperty.propertyManager.name}</p>
                            <p className="text-sm text-gray-500">{selectedProperty.propertyManager.email}</p>
                            <p className="text-sm text-gray-500">{selectedProperty.propertyManager.phone}</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="mt-6 border-t border-gray-200 pt-6">
                    <div className="flex justify-end space-x-3">
                      <button
                        onClick={() => setIsDetailsModalOpen(false)}
                        className="inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm"
                      >
                        Close
                      </button>
                      <button
                        onClick={() => {
                          setIsDetailsModalOpen(false);
                          // Navigate to full property details page
                          navigate(`/admin/properties/${selectedProperty.id}`);
                        }}
                        className="inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm"
                      >
                        View Full Details
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}