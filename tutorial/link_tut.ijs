
NB. folder links allow placing columns in folders other than the db folder
NB. Windows folder junctions
NB. Unix symbolic folder links
NB. possible benefits of placing cols on different drives
NB.  some cols can be placed on ssd drive for performance
NB.  i/o load balancing across drives
NB.  total db size irrelevant - only limit is biggest col must fit on a drive

NB. examples place cols in alternate folders in ~temp for convenience
NB. in real use they would be placed on different drives

NB. jdlinkset sets link definitions for the db
NB. any createcol done will adjust according to the link definitions
NB.  including csvrd and csvrestore

CSVFOLDER=: '~temp/jd/csv/test/'
jddeletefolder_jd_ CSVFOLDER
jdadminx'test'
jd'gen test f 3'
jd'csvwr f.csv f'

NB. locate f/int col in alternate folder
jdadminx'test'
NB.jdlinkset set links from tab/col to path
jdlinkset_jd_ 'f/int ~temp/linker'
jd'csvrd f.csv f'
sptable jdlinktargets_jd_'' NB. report link target
NB. look at the db folder with OS tools to see the link to the target

NB. locate f/varbyte col (dat and val) in alternate folder
jdadminx'test'
NB.jdlinkset set links from tab/col to path
jdlinkset_jd_ 'f/varbyte ~temp/linker'
jd'csvrd f.csv f'
sptable jdlinktargets_jd_'' NB. report link target
NB. look at the db folder with OS tools to see the link to the target

NB. locate f/int and f/varbye in different alternate folders
jdadminx'test'
jdlinkset_jd_ 0 : 0
f/int     ~temp/linker0
f/varbyte ~temp/linker1
)
jd'csvrd f.csv f'
sptable ,.jdlinktargets_jd_'' NB. report link targets

NB. locate f/a0, f/a1 in alternate folder
jdadminx'test'
jdlinkset_jd_ 0 : 0
f/a0       ~temp/linker0
f/a1       ~temp/linker0
)
jd'csvrd f.csv f'
sptable ,.jdlinktargets_jd_'' NB. report link targets

NB. jdlinkset persists
jd'droptable f'
jd'csvrd f.csv f'
sptable ,.jdlinktargets_jd_'' NB. report link targets

NB. ref cols can be linked
jdadminx'test'
jdlinkset_jd_ 'f/jdref_a2_g_b2 ~temp/linker'
jd'gen two f 10 g 5'
jd'ref f a2 g b2'
sptable jdlinktargets_jd_''

NB. varbyte cols (dat and val) can be linked
jdadminx'test'
jdlinkset_jd_ 'f/varbyte ~temp/linker'
jd'gen test f 3'
sptable jdlinktargets_jd_''

NB. it is possible to relocate a column to another location
NB. note that this is independent from jdlinkset and does not adjust the linkj definitions
jdadminx'test'
jddeletefolder_jd_  '~temp/linker'
jd'gen one f 3 2'
jdlinkmove_jd_ 'f/a0 ~temp/linker'
jdlinktargets_jd_''
