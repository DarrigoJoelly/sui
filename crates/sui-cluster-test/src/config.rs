use std::path::PathBuf;

// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
use clap::*;

#[derive(Parser, Clone, ValueEnum, Debug)]
pub enum Env {
    Devnet,
    Staging,
    Ci,
    CiNomad,
    Testnet,
    CustomRemote,
    NewLocal,
}

#[derive(Parser, Debug)]
#[clap(name = "", rename_all = "kebab-case")]
pub struct ClusterTestOpt {
    #[clap(value_enum)]
    pub env: Env,
    #[clap(long)]
    pub faucet_address: Option<String>,
    #[clap(long)]
    pub fullnode_address: Option<String>,
    #[clap(long)]
    pub epoch_duration_ms: Option<u64>,
    /// URL for the indexer RPC server
    #[clap(long)]
    pub indexer_address: Option<String>,
    /// Use new version of indexer or not
    #[clap(long)]
    pub use_indexer_v2: bool,
    /// URL for the Indexer Postgres DB
    #[clap(long)]
    pub pg_address: Option<String>,
    /// TODO(gegao): remove this after indexer migration is complete.
    #[clap(long)]
    pub use_indexer_experimental_methods: bool,
    #[clap(long)]
    pub config_dir: Option<PathBuf>,
    /// URL for the indexer RPC server
    #[clap(long)]
    pub graphql_address: Option<String>,
}

impl ClusterTestOpt {
    pub fn new_local() -> Self {
        Self {
            env: Env::NewLocal,
            faucet_address: None,
            fullnode_address: None,
            epoch_duration_ms: None,
            indexer_address: None,
            pg_address: None,
            use_indexer_experimental_methods: false,
            config_dir: None,
            graphql_address: None,
            use_indexer_v2: false,
        }
    }
}
