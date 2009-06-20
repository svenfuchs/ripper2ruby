
  class Foo
    def foo
      t(:bar)
      t(:"baaar")
      t(:'baar', :scope => ['foo', :fooo], :default => 'bla')
      t(:'foo.bar')
      t("bar")
      t('bar_1')
      1 + 1
      t(1)
      t(1.1)
      t(1 + 1)
    end
    foo(:outside_)
  end
