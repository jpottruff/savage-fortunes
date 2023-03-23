<p align="center">
  <a href="https://github.com/jpottruff/savage-fortunes">
    <img src="./logo-banner.png" alt="Savage Fortunes Logo" width="240" height="240">
  </a>
</p>


### Basic Command Examples 
Utilize basic [fortune](https://linux.die.net/man/6/fortune) and [cowsay](https://linux.die.net/man/1/cowsay) commands
```bash
# Generate a basic savage fortune
fortune savage-fortunes

# Randy Savage now works for cowsay
cowsay -f savage <my things to say>

# Get a fortune from the Macho Man himself
fortune savage-fortunes | cowsay -f savage
```
### Alias Examples 
...or create some aliases

```bash
# ascii Macho Man tells you a fortune
alias savagefortune="fortune savage-fortunes | cowsay -f savage | lolcat"

# Use like you would cowsay
savagesay() {
  figlet -k $@ | cowsay -f savage -n | lolcat
}
```
# Setup (Script)

> ⚠️**Warning: USE AT YOUR OWN RISK**⚠️
>
> Full disclosure - bash scripts are **not** something I write very often. 
> 
> It pretty much just automates the manual setup steps below, but maybe go over it first to make sure it won't ruin your day.

You can run the [install script](https://github.com/jpottruff/savage-fortunes/blob/main/setup.sh) by downloading it or run from the command line using:

```bash
curl -o savage-setup.sh https://raw.githubusercontent.com/jpottruff/savage-fortunes/main/setup.sh && bash ./savage-setup.sh
```
_NOTE: Running the script will give you the **option** to append a couple aliases to either `.bash_aliases` or `.bashrc` that function similar to the alias examples above._
# Setup (Manual)

## Prereqs

Install fortune, cowsay, and the optional _(but recommended)_ dependencies 

```bash
# Required
sudo apt install fortune
sudo apt install cowsay

# Optional (used in demo alias / function above)
sudo apt install lolcat
sudo apt install figlet
```

## Initial Setup
1. Copy `savage-fortunes` and `savage-fortunes.dat` from project to the **fortunes directory** on your distro

    ```bash
    cd ./fortunes
    cp savage-fortunes savage-fortunes.dat /usr/share/games/fortunes
    ```

    _You should now be able to run them from any directory and see them in the list of available fortunes_

    ```bash
    # Check the file exists in the fortunes directory
    fortune -f 

    # Generate a savage fortune
    fortune savage-fortunes
    ```
1. Copy `savage.cow` from the project to the **cows directory** on your distro

    ```bash
    cd ./cows
    cp savage.cow /usr/share/cowsay/cows
    ```

## Editing the fortunes
The quotes can be edited as you like but you will need to generate a new `.dat` file. 

_NOTE: if you're editing the file directly in `/usr/share/games/fortunes/savage-fortunes`, you can simply generate/replace `.dat` there._

_If you're editing copies of the files that are stored elsewhere, you will need to replace the stale files in the fortunes directory with the new ones_

```bash
# Generate a .dat file
strfile -c % savage-fortunes savage-fortunes.dat
```
## Editing the cow
Make changes to the `.cow` file directly or use the included ascii art in the project. 

Information on how to create new cows can be found in article in the resources section. 

## Resources
[Fortune](https://linux.die.net/man/6/fortune)

[Creating a fortunes file](https://askubuntu.com/questions/36523/creating-a-fortunes-file)

[How to convert images into ascii format in linux](https://ostechnix.com/how-to-convert-images-into-ascii-format-in-linux/)

[Creating your own cowsay messenger](https://www.networkworld.com/article/3601114/creating-your-own-cowsay-messenger.html)