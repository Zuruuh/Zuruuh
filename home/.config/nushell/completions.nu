export def "nu-complete node scripts" [] {
    open package.json | get scripts | columns
}

export extern "node --run" [
    script: string@"nu-complete node scripts"
];
