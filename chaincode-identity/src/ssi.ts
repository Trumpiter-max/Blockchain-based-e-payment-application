import { Context, Contract, Info, Transaction } from 'fabric-contract-api';
import { NymTransaction } from './nymTransaction';
import { SchemaTransaction } from './schemaTransaction';
import { CredentialDefinitionTransaction } from './credentialDefinitionTransaction';

const TRANSACTION_TYPES = {
    NYM: 'nym',
    SCHEMA: 'schema',
    CREDENTIAL_DEFINITION: 'credentialDefinition',
};

@Info({ title: 'SSIChaincode', description: 'Smart contract for enabling SSI in Fabric' })
export class SSISmartContract extends Contract {

    @Transaction()
    public async CreateTransaction(ctx: Context, transaction: string, type: string, network: string): Promise<void> {
        let id: string;

        switch (type) {
            case TRANSACTION_TYPES.NYM:
                const nym: NymTransaction = JSON.parse(transaction);
                id = `did:${network}:${nym.operation.dest}`;
                await ctx.stub.putState(id, Buffer.from(JSON.stringify(nym)));
                break;

            case TRANSACTION_TYPES.SCHEMA:
                const schema: SchemaTransaction = JSON.parse(transaction);
                id = `${schema.identifier}:2:${schema.operation.data.name}:${schema.operation.data.version}`;
                await ctx.stub.putState(id, Buffer.from(JSON.stringify(schema)));
                break;

            case TRANSACTION_TYPES.CREDENTIAL_DEFINITION:
                const credentialDefinition: CredentialDefinitionTransaction = JSON.parse(transaction);
                id = `${credentialDefinition.identifier}:3:${credentialDefinition.operation.signature_type}:${credentialDefinition.operation.ref}:${credentialDefinition.operation.tag}`;
                await ctx.stub.putState(id, Buffer.from(JSON.stringify(credentialDefinition)));
                break;

            default:
                throw new Error(`Invalid transaction type: ${type}`);
        }
    }

    @Transaction(false)
    public async ReadTransaction(ctx: Context, id: string, type: string): Promise<any> {
        const txnJSON = await ctx.stub.getState(id);

        if (!txnJSON || txnJSON.length === 0) {
            throw new Error(`The txn ${id} does not exist`);
        }

        const transaction = await this.BinaryToArray(txnJSON);

        switch (type) {
            case TRANSACTION_TYPES.NYM:
                return this.formatNymTransaction(transaction);

            case TRANSACTION_TYPES.SCHEMA:
                return this.formatSchemaTransaction(transaction, id);

            case TRANSACTION_TYPES.CREDENTIAL_DEFINITION:
                return this.formatCredentialDefinitionTransaction(transaction, id);

            default:
                return txnJSON.toString();
        }
    }

    @Transaction()
    public async UpdateTransaction(ctx: Context, transaction: string, type: string, id: string): Promise<void> {
        const txnJSON = await ctx.stub.getState(id);
        const exists = txnJSON && txnJSON.length > 0;

        if (!exists) {
            throw new Error(`The transaction ${id} does not exist`);
        }

        switch (type) {
            case TRANSACTION_TYPES.NYM:
                const nym: NymTransaction = JSON.parse(transaction);
                await ctx.stub.putState(id, Buffer.from(JSON.stringify(nym)));
                break;

            case TRANSACTION_TYPES.SCHEMA:
            case TRANSACTION_TYPES.CREDENTIAL_DEFINITION:
                throw new Error(`The ${type} transaction cannot be updated`);
        }
    }

    @Transaction()
    public async DeleteTransaction(ctx: Context, id: string): Promise<void> {
        const txnJSON = await ctx.stub.getState(id);
        const exists = txnJSON && txnJSON.length > 0;

        if (!exists) {
            throw new Error(`The transaction ${id} does not exist`);
        }

        await ctx.stub.deleteState(id);
    }

    public async BinaryToArray(binArray): Promise<any> {
        const str = Buffer.from(binArray).toString('utf8');
        return JSON.parse(str);
    }

    private formatNymTransaction(nym: NymTransaction): any {
        return {
            did: nym.operation.dest,
            verkey: nym.operation.verkey,
            role: nym.operation.role,
        };
    }

    private formatSchemaTransaction(schema: SchemaTransaction, id: string): any {
        return {
            ver: '1.0',
            id: id,
            name: schema.operation.data.name,
            version: schema.operation.data.version,
            attrNames: schema.operation.data.attr_names,
            seqNo: 0,
        };
    }

    private formatCredentialDefinitionTransaction(
        credentialDefinition: CredentialDefinitionTransaction,
        id: string
    ): any {
        return {
            ver: '1.0',
            id: id,
            schemaId: '0',
            type: credentialDefinition.operation.signature_type,
            tag: credentialDefinition.operation.tag,
            value: {
                primary: credentialDefinition.operation.data.primary,
                revocation: credentialDefinition.operation.data.revocation,
            },
        };
    }
}