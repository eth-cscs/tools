from easybuild.easyblocks.generic.toolchain import Toolchain

class CrayToolchain(Toolchain):

    def make_module_dep(self):
        txt = super(CrayToolchain, self).make_module_dep()
	return self.module_generator.unload_module('PrgEnv-cray') + txt
