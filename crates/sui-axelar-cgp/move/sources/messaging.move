// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module axelar::messaging {
    use std::string;
    use std::string::String;

    #[test_only]
    use std::vector;

    /// CallApproval struct which can consumed only by a `Channel` object.
    /// Does not require additional generic field to operate as linking
    /// by `id_bytes` is more than enough.
    ///
    struct CallApproval {
        /// ID of the call approval, guaranteed to be unique by Axelar.
        cmd_id: vector<u8>,
        /// The target Channel's UID.
        target_id: address,
        /// Name of the chain where this approval came from.
        source_chain: String,
        /// Address of the source chain (vector used for compatibility).
        /// UTF8 / ASCII encoded string (for 0x0... eth address gonna be 42 bytes with 0x)
        source_address: String,
        /// Hash of the full payload (including source_* fields).
        payload_hash: vector<u8>,
        /// The rest of the payload to be used by the application.
        payload: vector<u8>,
    }

    struct StoredCallApproval has store {
        /// The target Channel's UID.
        target_id: address,
        /// Name of the chain where this approval came from.
        source_chain: String,
        /// Address of the source chain (vector used for compatibility).
        /// UTF8 / ASCII encoded string (for 0x0... eth address gonna be 42 bytes with 0x)
        source_address: String,
        /// Hash of the full payload (including source_* fields).
        payload_hash: vector<u8>,
        /// The rest of the payload to be used by the application.
        payload: vector<u8>,
    }

    public fun create(
        cmd_id: vector<u8>,
        source_chain: vector<u8>,
        source_address: vector<u8>,
        target_id: address,
        payload_hash: vector<u8>,
        payload: vector<u8>): CallApproval {
        CallApproval {
            cmd_id,
            source_chain: string::utf8(source_chain),
            source_address: string::utf8(source_address),
            target_id,
            payload_hash,
            payload,
        }
    }

    public fun from_stored_approval(cmd_id: vector<u8>, msg: StoredCallApproval): CallApproval {
        let StoredCallApproval {
            target_id,
            source_chain,
            source_address,
            payload_hash,
            payload,
        } = msg;

        CallApproval {
            cmd_id,
            source_chain,
            source_address,
            target_id,
            payload_hash,
            payload,
        }
    }

    public fun to_stored_approval(approval: CallApproval): (vector<u8>, StoredCallApproval) {
        let CallApproval {
            cmd_id,
            target_id,
            source_chain,
            source_address,
            payload_hash,
            payload,
        } = approval;

        (cmd_id, StoredCallApproval {
            target_id,
            source_chain,
            source_address,
            payload_hash,
            payload,
        })
    }

    public fun consume_call_approval(approval: CallApproval): (String, String, vector<u8>, vector<u8>) {
        let CallApproval {
            cmd_id : _,
            target_id : _,
            source_chain,
            source_address,
            payload_hash,
            payload,
        } = approval;
        (source_chain, source_address, payload_hash, payload)
    }

    public fun target_id(msg: &CallApproval): address {
        msg.target_id
    }

    #[test_only]
    /// Handy method for burning `vector<CallApproval>` returned by the `execute` function.
    public fun delete(approvals: vector<CallApproval>) {
        while (vector::length(&approvals) > 0) {
            let CallApproval {
                cmd_id: _,
                target_id: _,
                source_chain: _,
                source_address: _,
                payload_hash: _,
                payload: _
            } = vector::pop_back(&mut approvals);
        };
        vector::destroy_empty(approvals);
    }
}
