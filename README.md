# Savage Fortunes

## Prereqs
Install fortune
```bash
sudo apt install fortune
```

## Initial Setup
Copy the `savage-fortunes` and `savage-fortunes.dat` to the fortunes directory

```bash
cp savage-fortunes savage-fortunes.dat /usr/share/games/fortunes
```

You should now be able to run them from any directory and see them in the list of available fortunes

```bash
# Check the file exists in the fortunes directory
fortune -f 

# Generate a savage fortune
fortune savage-fortunes
```

## Editing the quotes
The quotes can be edited as you like but you will need to generate a new `.dat` file. 

_NOTE: if editing the file directly in `/usr/share/games/fortunes/savage-fortunes`, simply generate/replace `.dat` there._

_If editing copies of the files that are stored elsewhere, you will need to replace the stale files in the fortunes directory with the new ones_

```bash
strfile -c % savage-fortunes savage-fortunes.dat
```

## Resources
[Fortune](https://linux.die.net/man/6/fortune)

[Creating a fortunes file](https://askubuntu.com/questions/36523/creating-a-fortunes-file)