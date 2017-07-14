package deengames.incrementalwar.model;

enum Discovery {
    // TODO: make these universe-specific

    // These are listed chronologically in order of discovery
    ManuallyMineAlloy; // requires energy
    AlloyHarvester; // requires 10 alloy
    ManuallyMineNeodymium; // requires 3 alloy harvesters
    NeodymiumHarvester; // requires 10 nedymium
}