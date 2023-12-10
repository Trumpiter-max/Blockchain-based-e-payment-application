import React, { useState } from 'react';
import axios from 'axios';

function SubmitTransaction() {
    const [transaction, setTransaction] = useState({});
    const [type, setType] = useState('');

    const handleSubmitTransaction = async () => {
        try {
            await axios.post(`http://localhost:3000/test/${type}`, transaction);
            // Handle success
        } catch (error) {
            // Handle error
        }
    };

    return (
        <div>
            {/* Your form components for transaction details */}
            <button onClick={handleSubmitTransaction}>Submit Transaction</button>
        </div>
    );
}

export default SubmitTransaction;