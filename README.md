# devops-netology

Домашнее задание к занятию «2.4. Инструменты Git» выполнено

1.  aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    Update CHANGELOG.md

git log --pretty=format:"%H : %s" | findstr aefea

2.  v0.12.23

git describe --exact-match 85024d3

3.  Два
    56cd7859e05c36c06b56d013b55a252d0bb7e158 
    9ea88f22fc6269854151c571162c5bcf958bee2b

git log --pretty=%P -n 1 b8d720

4.  b14b74c49 [Website] vmc provider links
    3f235065b Update CHANGELOG.md
    6ae64e247 registry: Fix panic when server is unreachable
    5c619ca1b website: Remove links to the getting started guide's old location
    06275647e Update CHANGELOG.md
    d5f9411f5 command: Fix bug when using terraform login on Windows
    4b6d06cc5 Update CHANGELOG.md
    dd01a3507 Update CHANGELOG.md
    225466bc3 Cleanup after v0.12.23 release

git log v0.12.23..v0.12.24 --oneline

5.  8c928e83589d90a031f811fae52a81be7153e82f

git grep -n providerSource
git log -L :providerSource:provider_source.go


6.  78b12205587fe839f10d946ea3fdc06719decb05
    52dbf94834cb970b510f2fba853a5b49ad9b1a46
    41ab0aef7a0fe030e84018973a64135b11abcd70
    66ebff90cdfaa6938f26f908c7ebad8d547fea17

git grep -n globalPluginDirs
git log -L :globalPluginDirs:plugins.go

7.  Author: Martin Atkins

git log -S synchronizedWriters