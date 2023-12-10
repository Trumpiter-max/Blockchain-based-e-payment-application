import React, { useState } from 'react';
import axios from 'axios';

function UseOrganization() {
    const [organizationDetails, setOrganizationDetails] = useState({});

    const handleUseOrganization = async () => {
        try {
            await axios.post('http://localhost:3000/useorganization', organizationDetails);
            // Handle success
        } catch (error) {
            // Handle error
        }
    };

    return (
        <div>
            {/* Your form components for organization details */}
            <button onClick={handleUseOrganization}>Use Organization</button>
        </div>
    );
}

export default UseOrganization;
