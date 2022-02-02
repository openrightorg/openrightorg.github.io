# IPFS

*by Don Mahurin, 2022-02-02*

This document is for those who wish to try out IPFS, the main protocol behind the decentralized web (Web 3.0).

The basic instructions given here show how to add and maintain files on the IPFS network.

We will be adding files, tracking those files, sharing the files on IPFS.

This document assumes that you have installed the command line 'ipfs' tools.

https://docs.ipfs.tech/install/command-line/

## Create a directory to hold IPFS

```
mkdir somedir
cd somedir
```

Put some files in the directory you created.
```
cp openright_files/* somedir
```

Add the files to your local ipfs store
```
ipfs add --cid-version=1 somedir
added bafybeids6rcqp5vqkpzdvkmsc6jhymava64z3o3kusajpcbgnj5uujnyim somedir/openright.png
added bafybeicchzu3ldqfaeay7gfuyysc7crtyhm7i7wryvqk3ahee5e5ywf6h4 somedir/index.html
added bafybeidcgrz6a2etxdt5ouz6xjeatdggpaa4up5mrmkdkk5lhb5xd4vide somedir/bootstrap-dark.css
added bafybeid2yck2uc5bbubw2vlqcjzbiefxx3g6eg2yxngyhyecmbp27mamgm somedir
```

*Note, here we use --cid-version=1 for ipfs addresses, as this is what is recommended and used with browsers and other contexts.*

Pin the directory, So it will be tracked by default
```
ipfs pin add bafybeid2yck2uc5bbubw2vlqcjzbiefxx3g6eg2yxngyhyecmbp27mamgm
```

You can see what recursive/directory pins you have with:
```
ipfs pin ls -l --type=recursive
```

Use "ipfs files", to maintain and track your files like a Unix file system.

```
ipfs files cp /ipfs/bafybeid2yck2uc5bbubw2vlqcjzbiefxx3g6eg2yxngyhyecmbp27mamgm /openright
ipfs files ls /openright
```

You will need to run an ipfs node in order for other nodes to see your files
```
ipfs daemon
```

Now you can view your files in a browser that supports ipfs (like Brave).

```
ipfs://bafybeid2yck2uc5bbubw2vlqcjzbiefxx3g6eg2yxngyhyecmbp27mamgm
```

Continued topics:
- Setup IPNS as common pointer to create a mutable pointer to your files
- Setup DNS to point to IPFS or IPNS 
