import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import SetupOrganization from './components/SetupOrganization';
import UseOrganization from './components/UseOrganization';
import SubmitTransaction from './components/SubmitTransaction';
import ViewTransactions from './components/ViewTransactions';

function App() {
  return (
    <Router>
      <Switch>
        <Route path="/setup" component={SetupOrganization} />
        <Route path="/useorganization" component={UseOrganization} />
        <Route path="/submittransaction" component={SubmitTransaction} />
        <Route path="/viewtransactions" component={ViewTransactions} />
      </Switch>
    </Router>
  );
}

export default App;