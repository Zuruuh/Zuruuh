export def "nu-complete node scripts" [] {
    open package.json | get scripts | columns
}

export def "nu-complete composer scripts" [] {
    open composer.json | get scripts | columns
}

export extern "node --run" [
    script: string@"nu-complete node scripts"
];

export extern "composer run" [
    script: string@"nu-complete composer scripts"
];
